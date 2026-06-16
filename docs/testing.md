# Testing Strategy

Target coverage is greater than 90% for domain, use-case, repository-adapter, AI workflow, and critical mobile interaction code.

Required suites:

- Unit tests for entities, validators, command parsing, and intent mapping.
- Repository tests against Firebase emulators.
- Widget tests for dashboard, navigation, compact viewport safety, auth, voice, inventory, OCR review, sales, reminder, settings, and onboarding flows.
- Integration tests for offline inventory updates followed by sync.
- Security rule tests for business membership boundaries.
- AI workflow tests using recorded schema-valid responses.

The current suite includes domain, AI intent, navigation-state, compact-viewport, and mobile-flow widget tests covering onboarding, login, voice, inventory, scanner, sales, payments, settings, global search, and bottom-tab state preservation. Emulator, integration, golden, and accessibility suites should be added after Firebase project configuration is generated.
