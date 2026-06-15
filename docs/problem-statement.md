# Problem Statement

## Background

Small businesses in India often manage stock, sales, invoices, and customer dues across notebooks, WhatsApp chats, spreadsheets, and disconnected apps. These workflows are familiar, but they are hard to search, reconcile, and operate consistently during busy shop hours.

Many merchants also work across multiple Indian languages and may not want dense, form-heavy software for daily tasks. A useful business assistant must support voice-first actions, offline usage, fast recovery from mistakes, and clear review steps before important data changes are saved.

## Core Problem

Vaani AI aims to reduce the time and effort required for small merchants to manage routine business operations by turning natural voice commands, invoice scans, and simple mobile interactions into validated business actions.

The product must solve four practical gaps:

- Fast inventory updates without navigating complex forms.
- Sales and payment tracking that fits real shop workflows.
- Invoice capture that reduces manual entry while keeping merchants in control.
- AI assistance that is helpful, multilingual, and safe enough for business data.

## Target Users

- Kirana stores and neighborhood retailers.
- Small wholesalers and distributors.
- Service providers who track customer dues.
- Owner-operators who need mobile-first workflows instead of desktop software.

## Success Criteria

- Merchants can complete frequent tasks such as stock updates, sales entry, invoice review, and payment reminders in a few taps or through voice.
- The app remains useful when connectivity is poor by queuing operations locally and syncing them later.
- AI output is converted into typed, validated actions instead of directly mutating business records.
- Sensitive provider credentials are never shipped in the client app.
- The system can grow from a Flutter/Firebase foundation into production with authentication, Cloud Functions, monitoring, and emulator-backed tests.

## Scope

The current repository provides a production-oriented foundation rather than a finished production app. It includes the Flutter app structure, mobile UI flow, Firebase-ready data layer, voice and AI abstractions, offline sync foundation, security rules, and starter tests.

Production work still requires full Firebase configuration, completed CRUD flows, OCR review implementation, payment provider integrations, Cloud Functions gateways, release monitoring, and expanded automated testing.
