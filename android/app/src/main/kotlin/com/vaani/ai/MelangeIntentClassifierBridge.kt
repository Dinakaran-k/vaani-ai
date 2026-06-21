package com.vaani.ai

import android.content.Context
import com.zeticai.mlange.core.model.llm.LLMInitOption
import com.zeticai.mlange.core.model.llm.LLMKVCacheCleanupPolicy
import com.zeticai.mlange.core.model.llm.LLMModelMode
import com.zeticai.mlange.core.model.llm.ZeticMLangeLLMModel
import org.json.JSONArray
import org.json.JSONObject
import java.io.Closeable
import java.util.Locale
import java.util.concurrent.atomic.AtomicReference

internal class MelangeIntentClassifierBridge(
    private val context: Context,
) : Closeable {
    private val voiceIntentModel = AtomicReference<ZeticMLangeLLMModel?>()
    private val invoiceModel = AtomicReference<ZeticMLangeLLMModel?>()
    private val lock = Any()

    fun isReady(): Boolean {
        return BuildConfig.MELANGE_PERSONAL_KEY.isNotBlank() &&
            BuildConfig.MELANGE_VOICE_INTENT_MODEL_NAME.isNotBlank() &&
            BuildConfig.MELANGE_INVOICE_MODEL_NAME.isNotBlank() &&
            BuildConfig.MELANGE_ASR_ENCODER_MODEL_NAME.isNotBlank() &&
            BuildConfig.MELANGE_ASR_DECODER_MODEL_NAME.isNotBlank()
    }

    fun describeModels(): Map<String, Any?> {
        return mapOf(
            "voiceIntentModel" to BuildConfig.MELANGE_VOICE_INTENT_MODEL_NAME,
            "invoiceModel" to BuildConfig.MELANGE_INVOICE_MODEL_NAME,
            "asrEncoderModel" to BuildConfig.MELANGE_ASR_ENCODER_MODEL_NAME,
            "asrDecoderModel" to BuildConfig.MELANGE_ASR_DECODER_MODEL_NAME,
            "asrModel" to BuildConfig.MELANGE_ASR_MODEL_NAME,
            "languageModel" to BuildConfig.MELANGE_LANGUAGE_MODEL_NAME,
            "inventoryModel" to BuildConfig.MELANGE_INVENTORY_MODEL_NAME,
            "ready" to isReady(),
        )
    }

    fun classifyIntent(
        utterance: String,
        locale: String,
        businessContext: Map<*, *>,
    ): Map<String, Any?> {
        if (!isReady()) {
            return unknownIntent(utterance)
        }

        val prompt = buildIntentPrompt(utterance, locale, businessContext)
        val raw = runPrompt(
            modelRef = voiceIntentModel,
            modelName = BuildConfig.MELANGE_VOICE_INTENT_MODEL_NAME,
            prompt = prompt,
        )
        return parseIntentResponse(raw, utterance)
    }

    fun extractInvoice(ocrText: String, locale: String = "en-IN"): Map<String, Any?> {
        if (!isReady()) {
            return emptyInvoiceResponse(ocrText)
        }

        val prompt = buildInvoicePrompt(ocrText, locale)
        val raw = runPrompt(
            modelRef = invoiceModel,
            modelName = BuildConfig.MELANGE_INVOICE_MODEL_NAME,
            prompt = prompt,
        )
        return parseInvoiceResponse(raw, ocrText)
    }

    override fun close() {
        synchronized(lock) {
            voiceIntentModel.getAndSet(null)?.deinit()
            invoiceModel.getAndSet(null)?.deinit()
        }
    }

    private fun runPrompt(
        modelRef: AtomicReference<ZeticMLangeLLMModel?>,
        modelName: String,
        prompt: String,
    ): String {
        val model = ensureModel(modelRef, modelName)
        model.cleanUp()
        model.run(prompt)

        val output = StringBuilder()
        while (true) {
            val nextToken = model.waitForNextToken()
            if (nextToken.generatedTokens == 0) break
            if (nextToken.token.isNotEmpty()) {
                output.append(nextToken.token)
            }
        }
        model.cleanUp()
        return output.toString().trim()
    }

    private fun ensureModel(
        modelRef: AtomicReference<ZeticMLangeLLMModel?>,
        modelName: String,
    ): ZeticMLangeLLMModel {
        modelRef.get()?.let { return it }

        synchronized(lock) {
            modelRef.get()?.let { return it }
            val loaded = ZeticMLangeLLMModel(
                context = context,
                personalKey = BuildConfig.MELANGE_PERSONAL_KEY,
                name = modelName,
                modelMode = LLMModelMode.RUN_AUTO,
                initOption = LLMInitOption(
                    kvCacheCleanupPolicy = LLMKVCacheCleanupPolicy.CLEAN_UP_ON_FULL,
                    nCtx = 2048,
                ),
            )
            modelRef.set(loaded)
            return loaded
        }
    }

    private fun buildIntentPrompt(
        utterance: String,
        locale: String,
        businessContext: Map<*, *>,
    ): String {
        val contextJson = toJsonObject(businessContext).toString()
        return """
You are Vaani AI running entirely on-device for a small business app.
Return only JSON and no markdown or prose.

Allowed intents:
- add_inventory
- sales_today
- low_stock
- pending_payments
- unknown

Rules:
- If the command means adding stock, return add_inventory with productName, quantity, and unit.
- If the command is about sales today, return sales_today.
- If the command is about low stock, return low_stock.
- If the command is about pending dues or unpaid payments, return pending_payments.
- Otherwise return unknown.
- Keep productName, quantity, and unit null unless intent is add_inventory.

Locale: $locale
Business context: $contextJson
User command: $utterance
""".trimIndent()
    }

    private fun buildInvoicePrompt(
        ocrText: String,
        locale: String,
    ): String {
        return """
You are Vaani AI running entirely on-device for invoice understanding.
Return only JSON and no markdown or prose.

Extract these fields from the invoice text:
- vendorName
- invoiceNumber
- invoiceDate
- gstNumber
- totalAmount
- items: array of objects with name, quantity, unit, price

Rules:
- Return null for missing scalar fields.
- Return an empty array for items if no clear line items exist.
- Keep output compact and valid JSON.

Locale: $locale
Invoice text: $ocrText
""".trimIndent()
    }

    private fun parseIntentResponse(
        rawResponse: String,
        utterance: String,
    ): Map<String, Any?> {
        val candidate = extractJsonObject(rawResponse)
        if (candidate.isNullOrBlank()) {
            return unknownIntent(utterance)
        }

        return try {
            val json = JSONObject(candidate)
            val intent = json.optString("intent", "unknown").ifBlank { "unknown" }
            mapOf(
                "intent" to intent,
                "productName" to nullableString(json, "productName"),
                "quantity" to nullableNumber(json, "quantity"),
                "unit" to nullableString(json, "unit"),
                "originalText" to utterance,
            )
        } catch (_: Exception) {
            unknownIntent(utterance)
        }
    }

    private fun parseInvoiceResponse(
        rawResponse: String,
        ocrText: String,
    ): Map<String, Any?> {
        val candidate = extractJsonObject(rawResponse)
        if (candidate.isNullOrBlank()) {
            return emptyInvoiceResponse(ocrText)
        }

        return try {
            val json = JSONObject(candidate)
            val items = json.optJSONArray("items")?.let { array ->
                buildList {
                    for (index in 0 until array.length()) {
                        val itemJson = array.optJSONObject(index) ?: continue
                        add(
                            mapOf(
                                "name" to nullableString(itemJson, "name"),
                                "quantity" to nullableNumber(itemJson, "quantity"),
                                "unit" to nullableString(itemJson, "unit"),
                                "price" to nullableNumber(itemJson, "price"),
                            ),
                        )
                    }
                }
            } ?: emptyList()

            mapOf(
                "vendorName" to nullableString(json, "vendorName"),
                "invoiceNumber" to nullableString(json, "invoiceNumber"),
                "invoiceDate" to nullableString(json, "invoiceDate"),
                "gstNumber" to nullableString(json, "gstNumber"),
                "totalAmount" to nullableNumber(json, "totalAmount"),
                "items" to items,
                "originalText" to ocrText,
            )
        } catch (_: Exception) {
            emptyInvoiceResponse(ocrText)
        }
    }

    private fun extractJsonObject(rawResponse: String): String? {
        val match = Regex("""\{[\s\S]*\}""").find(rawResponse)
        return match?.value
    }

    private fun nullableString(json: JSONObject, key: String): String? {
        if (!json.has(key) || json.isNull(key)) return null
        val value = json.optString(key, "")
        return if (value.isBlank()) null else value
    }

    private fun nullableNumber(json: JSONObject, key: String): Double? {
        if (!json.has(key) || json.isNull(key)) return null
        return try {
            json.getDouble(key)
        } catch (_: Exception) {
            try {
                json.getInt(key).toDouble()
            } catch (_: Exception) {
                null
            }
        }
    }

    private fun unknownIntent(utterance: String): Map<String, Any?> {
        return mapOf(
            "intent" to "unknown",
            "productName" to null,
            "quantity" to null,
            "unit" to null,
            "originalText" to utterance,
        )
    }

    private fun emptyInvoiceResponse(ocrText: String): Map<String, Any?> {
        return mapOf(
            "vendorName" to null,
            "invoiceNumber" to null,
            "invoiceDate" to null,
            "gstNumber" to null,
            "totalAmount" to null,
            "items" to emptyList<Any>(),
            "originalText" to ocrText,
        )
    }

    private fun toJsonObject(map: Map<*, *>): JSONObject {
        val json = JSONObject()
        for ((key, value) in map) {
            if (key is String) {
                json.put(key, value ?: JSONObject.NULL)
            }
        }
        return json
    }
}
