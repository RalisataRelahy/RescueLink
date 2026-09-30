# Changelog

All notable changes to the RescueLink project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-09-27

### Added
- **Complete Test Suite**: Integrated over 19 Unit Tests, 10 Widget Tests, and 3 End-to-End Integration Tests.
- **Automated CI/CD Integration Testing**: GitHub Actions workflow updated with Linux headless desktop integration test execution step (`xvfb-run`).
- **Accessibility & i18n Hardening**: Screen reader semantics labels on interactive widgets, dynamic High Contrast mode, and official FR/EN locale switching.
- **Performance Optimizations**: Targeted Riverpod rebuilding, image compression pipeline, `const` constructor usage, and lazy-loaded scroll views.
- **Documentation**: Professional README with badges, architecture overview, visual showcase diagrams, and performance & accessibility benchmarks.

## [0.2.0] - 2026-09-15

### Added
- **Offline-First Storage**: Sqflite local database caching for incidents, notifications, and offline queue.
- **Auto-Sync Engine**: Reactive `SyncService` utilizing `connectivity_plus` to upload offline reports seamlessly upon reconnect.
- **Deterministic Priority Engine**: `PriorityCalculator` calculating priority levels (Low, Medium, High, Critical) based on category, affected headcount, road obstruction, and risk zone proximity.
- **Interactive Cartography**: OpenStreetMap tile layer integration via `flutter_map`, custom priority color markers, and translucence critical risk zones.
- **Incident Timeline**: Historical status tracking (`REPORTED` -> `ACKNOWLEDGED` -> `IN_PROGRESS` -> `RESOLVED` / `CANCELLED`).

## [0.1.0] - 2026-09-01

### Added
- **Core Architecture**: Feature-first folder layout using Riverpod 2.6, GoRouter 14, and Supabase Flutter SDK.
- **Authentication**: Email/password authentication flow with route guards and automatic profile creation.
- **Theme & Styling**: Material 3 Light and Dark theme configurations with custom color system.
- **Dashboard UI**: Summary statistic counters, local risk score calculation banner, and recent activity feed.
