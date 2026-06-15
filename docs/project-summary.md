# Vaani AI Project Summary

## Project Title

Vaani AI: Multilingual Voice Assistant for Small Businesses

## Overview

Vaani AI is a Flutter and Firebase-based mobile app foundation for small businesses in India. It helps merchants manage inventory, sales, invoice scanning, and payment reminders through voice-first, mobile-first workflows.

The app is designed for multilingual usage across English, Hindi, Tamil, Telugu, Bengali, Marathi, Kannada, Malayalam, Punjabi, Gujarati, and Hinglish. It combines deterministic command handling, AI intent routing, OCR-assisted invoice capture, and offline-first synchronization.

## Problem Addressed

Small merchants often manage business operations through paper notes, spreadsheets, WhatsApp messages, and separate apps. These workflows are difficult to search, reconcile, and scale. Vaani AI provides a single assistant-driven interface for common daily operations while keeping the merchant in control of important data changes.

## Objectives

- Make inventory and sales workflows faster through voice and simple mobile interactions.
- Support Indian language usage for everyday merchant commands.
- Reduce manual invoice entry through OCR-assisted review.
- Track customer dues and payment reminders from the same app flow.
- Keep the app useful during poor connectivity through local queues and delayed sync.
- Protect business data by validating AI output before executing actions.

## Key Features

- Animated onboarding and branded mobile interface.
- Dashboard for daily business status and quick actions.
- Voice assistant entrypoint with speech-to-text and text-to-speech abstractions.
- AI intent classification with deterministic shortcuts and remote AI client wrappers.
- Inventory domain model, Firestore repository, and stock update workflows.
- Invoice scanner screen foundation and OCR result model.
- Payment reminder model and Udhaar reminder screen foundation.
- Sales domain model and sales screen foundation.
- Offline sync queue foundation.
- Firebase security rules and indexes.
- Starter unit and widget tests.

## Technology Stack

- Flutter and Dart for the mobile app.
- Riverpod for dependency wiring.
- GoRouter for navigation.
- Firebase Auth, Cloud Firestore, Firebase Storage, Firebase Messaging, Analytics, and Crashlytics.
- Hive and SQLite planned for local-first persistence.
- Speech-to-text and text-to-speech for voice workflows.
- Google ML Kit OCR for invoice scanning.
- Gemini and OpenAI access through a planned secure Cloud Functions gateway.

## Architecture Summary

The project follows a feature-first clean architecture structure. Each major feature is separated into domain, data, application, and presentation layers where applicable.

Core architectural principles:

- The Flutter app owns user interaction and local validation.
- Firebase provides authentication, cloud storage, sync, and business data persistence.
- AI providers must be called through backend functions, not directly from a client that contains secrets.
- AI output is treated as a proposed typed action and must be validated before execution.
- Offline operations use queueing and idempotent sync operations to avoid unsafe duplicate writes.

## AI Usage

Vaani AI uses AI for natural language interpretation, not uncontrolled data mutation. Common commands should be handled through deterministic shortcuts first. Unmatched commands may be routed through Gemini or OpenAI through Cloud Functions. The returned intent must match a typed schema before the app performs any business operation.

## Current Status

The repository currently provides a production-oriented foundation rather than a complete production app. It includes core app structure, UI flow, data models, Firebase-ready repositories, AI and voice abstractions, sync foundations, documentation, and starter tests.

## Remaining Work

- Complete Firebase setup with FlutterFire CLI.
- Finish authentication UX and OAuth setup.
- Implement full inventory CRUD and local SQLite persistence.
- Build complete sales workflows, reports, PDF export, and Excel export.
- Complete OCR camera flow, invoice parsing, GST validation, and review UI.
- Add a Cloud Functions gateway for AI, WhatsApp, SMS, email, and provider secrets.
- Add App Check, Crashlytics, Analytics dashboards, release signing, and monitoring.
- Add emulator-backed security rule tests, integration tests, and broader widget coverage.

## Documentation Index

- [Problem statement](problem-statement.md)
- [AI features](ai-features.md)
- [Architecture](architecture.md)
- [Project structure](project-structure.md)
- [Testing strategy](testing.md)
- [DevOps](devops.md)
