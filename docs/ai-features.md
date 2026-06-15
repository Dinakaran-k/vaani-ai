# AI Features Documentation

## Overview

Vaani AI uses AI to help merchants operate the app through natural language, especially voice commands. The AI layer is designed as a routing and interpretation system: it identifies user intent, returns typed tool-call style results, and lets application code validate and execute the action.

AI is not allowed to directly mutate inventory, sales, payments, or invoice records. All AI output must pass through deterministic validation, permission checks, and repository methods.

## Implemented Foundation

The current codebase includes:

- Intent models in `lib/features/ai/domain/assistant_intent.dart`.
- AI client contracts in `lib/features/ai/domain/ai_client.dart`.
- Remote AI client wrappers in `lib/features/ai/data/remote_ai_clients.dart`.
- Hybrid intent classification in `lib/features/ai/data/hybrid_ai_intent_classifier.dart`.
- AI intent tests in `test/features/ai/hybrid_ai_intent_classifier_test.dart`.
- Voice entrypoints in `lib/features/voice`.

## Supported AI Capabilities

### Intent Classification

The assistant classifies user commands into structured intents. These intents represent business actions such as inventory updates, product lookup, sales-related workflows, OCR review support, and payment reminder assistance.

### Deterministic Shortcuts

Common commands should be resolved locally before using a remote model. This keeps frequent actions fast, lowers cost, improves reliability in low-connectivity conditions, and reduces the chance of unpredictable model output.

### Remote Model Routing

When a command cannot be resolved through local shortcuts, the app can route the transcript to a remote AI provider through a secure backend gateway. The README and architecture expect Gemini and OpenAI access to be brokered through Cloud Functions, not called with secrets embedded in the Flutter app.

### Multilingual Voice Assistance

The product targets English, Hindi, Tamil, Telugu, Bengali, Marathi, Kannada, Malayalam, Punjabi, Gujarati, and Hinglish. Speech recognition and text-to-speech are separated into the voice feature so language handling can evolve independently from AI intent routing.

### OCR-Assisted Workflows

Invoice scanning uses OCR as a separate capability from AI intent routing. Extracted invoice data should be reviewed by the merchant before it creates or updates inventory records.

## Safety Rules

- Never store OpenAI, Gemini, SMS, WhatsApp, email, or payment provider secrets in the Flutter client.
- Route remote model calls through authenticated Cloud Functions.
- Validate AI responses against typed schemas before execution.
- Require user review for OCR-derived business records.
- Treat inventory changes as quantity deltas so offline sync can reconcile them safely.
- Log or audit important sync operations with idempotent operation IDs.

## Planned Production Enhancements

- Cloud Functions gateway for Gemini and OpenAI.
- Strict JSON schema validation for model responses.
- Permission-aware tool execution based on business membership role.
- Recorded AI workflow test fixtures.
- Multilingual prompt and response templates.
- Analytics for failed classifications and fallback paths.
- Load tests for model-routing Cloud Functions.

## Related Files

- [Architecture](architecture.md)
- [Testing strategy](testing.md)
- [DevOps](devops.md)
