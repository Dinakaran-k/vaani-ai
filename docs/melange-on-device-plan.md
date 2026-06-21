# Melange On-Device Plan

## Why It Fits This Repo

Vaani AI already has the right product shape for an on-device AI product:

- Voice entrypoints are already device-local through `speech_to_text` and `flutter_tts`.
- The assistant already uses a hybrid classifier with deterministic shortcuts before any remote AI fallback.
- The scanner UI already keeps OCR review local before business data changes happen.

Melange adds the missing production bridge for the primary AI path on Android:

- On-device intent routing with `google/gemma-3n-E2B-it`.
- On-device invoice understanding with `Menlo/Jan-nano`.
- On-device speech is still pending the Whisper wrapper/import path from the official sample.
- Device-specific acceleration through Melange's Android SDK.

## Best Use Of Melange Here

The highest-value path is to move the assistant's primary AI functions onto-device instead of relying on remote provider calls:

1. Keep deterministic shortcuts in Dart for the most common merchant commands.
2. Replace the remote fallback with an Android Melange-backed Gemma intent model.
3. Keep OCR review and inventory mutation behind explicit user confirmation.
4. Treat Firebase as sync and identity infrastructure, not the source of AI execution.

## What We Can Use Today

- The local voice UX and language preferences.
- The deterministic AI shortcut layer in `HybridAiIntentClassifier`.
- The OCR review flow and scanner presentation.
- The offline-first architecture and validation rules.

## What Still Needs Android Work

- Deploy the selected Melange task models in your dashboard.
- Validate the model key and personal key values in `android/local.properties`.
- End-to-end verification on a physical Android device.
- Wire the Whisper speech bridge once the SDK wrapper/import path is available in the Melange sample app or published Android docs.
- Inspect the official `ZETIC_Melange_apps/apps/whisper-tiny` sample when the wrapper source is needed for the Android bridge.

## Current Android Bridge

The Android project now includes a method channel bridge at `vaani_ai/melange_ai` backed by the Melange Android SDK.

- Set `MELANGE_PERSONAL_KEY`, `MELANGE_VOICE_INTENT_MODEL_NAME`, `MELANGE_INVOICE_MODEL_NAME`, `MELANGE_ASR_ENCODER_MODEL_NAME`, and `MELANGE_ASR_DECODER_MODEL_NAME` in `android/local.properties`.
- The app now exposes task-specific model names for voice intent routing and invoice understanding in `android/local.properties.example`.
- The Flutter side can call the channel once the local properties are populated.
- The bridge loads Melange LLM models, prompts them for JSON intent or invoice output, and returns typed assistant data.
- The voice assistant screen now shows whether the bridge is ready for on-device inference.
- The Whisper speech path is still pending because the published AAR is stripped and does not expose the helper classes locally.
- The official ZETIC sample repo includes a `whisper-tiny` app, which is the next place to pull the missing wrapper/source from when available.

## Current Recommendation

The fastest production-credible story is:

`Flutter UI + deterministic local routing + Melange-powered Android AI execution + Firebase sync`

That gives you a genuine on-device primary AI path without throwing away the existing app foundation.
