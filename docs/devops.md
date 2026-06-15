# DevOps

## Environments

- `dev`: Firebase emulators, verbose logging, non-production AI gateway.
- `staging`: production-like Firebase project, seeded data, restricted testers.
- `prod`: App Check enforced, Crashlytics enabled, secret-backed Cloud Functions.

## Release Pipeline

1. `flutter pub get`
2. `dart format --set-exit-if-changed .`
3. `flutter analyze`
4. `flutter test --coverage`
5. Firebase rules deploy from `firebase.json`
6. Android App Bundle and iOS archive from protected release branches

## Secret Management

Client apps must not ship provider API keys for OpenAI, Gemini, SMS, WhatsApp, or SMTP. The app calls authenticated Cloud Functions, and those functions read provider credentials from Firebase Secret Manager.
