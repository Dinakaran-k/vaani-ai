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
    auth/               Email, Google, and phone OTP authentication.
    dashboard/          KPIs, charts, insights, and voice entrypoint.
    inventory/          Product CRUD, stock updates, low-stock alerts.
    ocr/                Invoice scan models and OCR workflow.
    payments/           Reminder scheduling and communication channels.
    sales/              Transactions, reports, export models.
    voice/              Speech-to-text and text-to-speech engines.
test/                   Unit and workflow tests.
docs/                   Project summary, problem statement, AI features, architecture, schemas, risks, and release guidance.
```

Feature folders use clean architecture:

- `domain`: entities and repository contracts.
- `data`: Firebase, local database, network, and device integrations.
- `application`: Riverpod providers and use cases.
- `presentation`: Flutter screens and widgets.

Primary documentation:

- [Problem statement](problem-statement.md)
- [Project summary](project-summary.md)
- [AI features](ai-features.md)
- [Architecture](architecture.md)
- [Testing strategy](testing.md)
- [DevOps](devops.md)
