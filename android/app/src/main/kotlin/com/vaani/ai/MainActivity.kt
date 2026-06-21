package com.vaani.ai

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.Executors

class MainActivity : FlutterActivity() {
    private val melangeExecutor = Executors.newSingleThreadExecutor()
    private lateinit var bridge: MelangeIntentClassifierBridge

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        bridge = MelangeIntentClassifierBridge(context = this)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_NAME)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "classifyIntent" -> classifyIntent(call.arguments, result)
                    "describeModels" -> result.success(bridge.describeModels())
                    "isReady" -> result.success(bridge.isReady())
                    else -> result.notImplemented()
                }
            }
    }

    override fun onDestroy() {
        melangeExecutor.shutdownNow()
        if (::bridge.isInitialized) {
            bridge.close()
        }
        super.onDestroy()
    }

    private fun classifyIntent(
        arguments: Any?,
        result: MethodChannel.Result,
    ) {
        if (!bridge.isReady()) {
                result.error(
                    "melange_not_configured",
                    "Set MELANGE_PERSONAL_KEY and the Melange model names in android/local.properties before running Melange.",
                    null,
                )
            return
        }

        val payload = arguments as? Map<*, *>
        val utterance = payload?.get("utterance") as? String ?: ""
        val locale = payload?.get("locale") as? String ?: "en-IN"
        val businessContext = payload?.get("businessContext") as? Map<*, *> ?: emptyMap<String, Any?>()

        melangeExecutor.execute {
            try {
                val classification = bridge.classifyIntent(
                    utterance = utterance,
                    locale = locale,
                    businessContext = businessContext,
                )
                runOnUiThread { result.success(classification) }
            } catch (error: Exception) {
                runOnUiThread {
                    result.error(
                        "melange_inference_failed",
                        error.message ?: "Melange inference failed",
                        null,
                    )
                }
            }
        }
    }

    companion object {
        private const val CHANNEL_NAME = "vaani_ai/melange_ai"
    }
}
