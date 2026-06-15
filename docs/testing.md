# Testing Strategy

Target coverage is greater than 90% for domain, use-case, repository-adapter, and AI workflow code.

Required suites:

- Unit tests for entities, validators, command parsing, and intent mapping.
- Repository tests against Firebase emulators.
- Widget tests for dashboard, inventory, auth, OCR review, and reminder flows.
- Integration tests for offline inventory updates followed by sync.
- Security rule tests for business membership boundaries.
- AI workflow tests using recorded schema-valid responses.

The current scaffold includes initial domain and AI intent tests. Emulator and integration suites should be added after Firebase project configuration is generated.
