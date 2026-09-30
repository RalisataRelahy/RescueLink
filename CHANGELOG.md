# Changelog

All notable changes to the RescueLink project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-09-27

### Added
- **Core Architecture**: Feature-first folder structure with Riverpod, GoRouter, and Supabase integration.
- **Offline-First Storage**: Sqflite local database caching with `SyncService` background network listener.
- **Priority Engine**: Deterministic `PriorityCalculator` algorithm (Low, Medium, High, Critical).
- **Dashboard**: Real-time summary counters, local Risk Score calculation banner, and recent incidents feed.
- **Incident Reporting**: Form with category dropdown, photo picker & compression, GPS location, and automatic priority calculation.
- **Map & Risk Zones**: FlutterMap OpenStreetMap integration, priority color-coded markers, and critical risk zone circle overlays.
- **Incident Details & History**: Incident timeline view tracking status changes (`REPORTED`, `ACKNOWLEDGED`, `IN_PROGRESS`, `RESOLVED`, `CANCELLED`).
- **Notifications**: Local notifications service for key incident lifecycle events.
- **Profile & Accessibility**: Dynamic language switcher (FR/EN), Theme mode selector (Light/Dark/System), and High Contrast mode.
- **Testing & CI/CD**: Unit test suite, Widget test suite, Integration test setup, and GitHub Actions workflow.
