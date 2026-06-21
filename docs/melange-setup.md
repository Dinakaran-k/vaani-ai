# Melange Setup

## Flutter-First Setup

This repo now treats Flutter as the primary integration surface:

- Flutter screens talk to a Riverpod-managed Melange service layer.
- The service layer falls back to the Android platform bridge when Melange is available.
- Local on-device command handling stays in Flutter first through the custom intent model.
- Shared Melange model-name defaults live in `lib/features/ai/data/melange_model_defaults.dart` so the Flutter UI can show a stable config view even when the Android bridge is unavailable.

## What This Repo Expects

The Android bridge reads one secret and a set of local model-name properties:

- `MELANGE_PERSONAL_KEY`
- `MELANGE_VOICE_INTENT_MODEL_NAME`
- `MELANGE_INVOICE_MODEL_NAME`
- `MELANGE_ASR_ENCODER_MODEL_NAME`
- `MELANGE_ASR_DECODER_MODEL_NAME`
- `MELANGE_ASR_MODEL_NAME` if you want to keep a legacy single-name alias
- `MELANGE_LANGUAGE_MODEL_NAME`
- `MELANGE_INVENTORY_MODEL_NAME`

Keep the secret out of source control. Use `android/local.properties` on your own machine.

## Quick Steps

1. Sign in to the Melange dashboard and claim or activate your access.
2. Open `Settings` or `Personal Access Tokens` in the dashboard.
3. Generate a new token or personal key for your project.
4. Copy that value into `MELANGE_PERSONAL_KEY` in `android/local.properties`.
5. Deploy the task models used by Vaani AI:
   - `google/gemma-3n-E2B-it` for voice intent routing
   - `Menlo/Jan-nano` for invoice understanding
   - `vaibhav-zetic/whisper_small_encoder` and `OpenAI/whisper-tiny-decoder` for Whisper speech-to-text
   - `SentenceTransformers/nli-MiniLM2-L6-H768` for language detection
   - `Qwen/Qwen3-Reranker-0.6B` for inventory prediction
6. Copy [android/local.properties.example](../android/local.properties.example) to `android/local.properties`.
7. Fill in the model names you deployed.
8. Link the Melange Android SDK dependency in `android/app/build.gradle.kts`.

## Access Token / Personal Key

The access token for this repo is the Melange personal key.

Use this flow:

1. Go to [https://melange.zetic.ai/](https://melange.zetic.ai/) and sign in.
2. Click `Claim now` and enter `MELANGEMOBILEHACKATHON` if you have not already claimed Pro access.
3. Open the dashboard settings and create a new personal access token.
4. Copy the generated token into `android/local.properties` as `MELANGE_PERSONAL_KEY`.
5. Keep it private and do not commit it.

## Recommended Model Choices

- `google/gemma-3n-E2B-it` for the primary on-device voice assistant path.
- `Menlo/Jan-nano` for OCR and invoice parsing.
- `vaibhav-zetic/whisper_small_encoder` plus `OpenAI/whisper-tiny-decoder` for the on-device Whisper speech layer.

## Important Constraint

This repository is prepared for a Melange-backed Android bridge, but you still need to deploy the selected Melange models in your dashboard before the bridge can run real on-device inference.
