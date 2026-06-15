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
5. `flutter build apk --debug` for Android build smoke testing
6. Firebase rules deploy from `firebase.json`
7. Android App Bundle and iOS archive from protected release branches

## Android Device Verification

For local Android checks:

```bash
flutter devices
flutter run -d <device-id>
```

If the build completes but the Flutter attach step hangs, install the generated debug APK directly:

```bash
flutter build apk --debug
adb -s <device-id> install -r build/app/outputs/flutter-apk/app-debug.apk
adb -s <device-id> shell monkey -p com.vaani.ai -c android.intent.category.LAUNCHER 1
```

Keep `android/local.properties`, Gradle caches, generated plugin registrants, signing keys, and downloaded build outputs out of source control. Commit the Android Gradle wrapper files so fresh clones and CI can build the Android target consistently.

## Secret Management

Client apps must not ship provider API keys for OpenAI, Gemini, SMS, WhatsApp, or SMTP. The app calls authenticated Cloud Functions, and those functions read provider credentials from Firebase Secret Manager.
