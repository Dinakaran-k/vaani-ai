# Project Structure

```text
lib/
  app/                  App shell, router, Material theme.
  core/
    bootstrap/          Startup initialization.
    errors/             Typed application exceptions.
    localization/       Supported Indian business languages.
    security/           Secure storage wrappers.
    sync/               Offline queue and background sync engine.
  features/
    ai/                 Intent classification and AI tool routing.
    auth/               Email, Google, and phone OTP authentication UI.
    dashboard/          KPIs, charts, insights, and voice entrypoint.
    inventory/          Product CRUD UI, stock updates, search, filters, low-stock alerts.
    ocr/                Camera scanner UI, invoice scan models, and OCR workflow.
    payments/           Reminder domain model, filters, due details, and local reminder state.
    sales/              Sale domain model, analytics UI, draft action, export/share feedback, and product insights.
    settings/           Language, voice, profile, tutorial, and support preference UI.
    voice/              Speech-to-text and text-to-speech engines.
android/                Android platform shell, manifests, Gradle config, wrapper, and launch assets.
test/                   Unit, navigation-state, and mobile-flow widget tests.
docs/                   Project summary, problem statement, AI features, architecture, DevOps, testing, and structure docs.
```

Feature folders use clean architecture:

- `domain`: entities and repository contracts.
- `data`: Firebase, local database, network, and device integrations.
- `application`: Riverpod providers and use cases.
- `presentation`: Flutter screens and widgets.

Primary documentation:

- [Project summary](project-summary.md)
- [Problem statement](problem-statement.md)
- [AI features](ai-features.md)
- [Architecture](architecture.md)
- [Testing strategy](testing.md)
- [DevOps](devops.md)
