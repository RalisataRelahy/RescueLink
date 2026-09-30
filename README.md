# RescueLink

[![CI/CD Pipeline](https://img.shields.io/badge/CI%2FCD-passing-brightgreen)](https://github.com/rescuelink/rescuelink/actions)
[![Flutter](https://img.shields.io/badge/Flutter-3.47.5-blue)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.13.4-blue)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

**RescueLink** est une application Flutter production-ready de signalement et de suivi d'incidents communautaires, conçue pour être **offline-first**, **accessible**, **performante** et **internationalisée (FR/EN)**.

---

## 📌 Features

- 📊 **Dashboard & Score de Risque** : Aperçu en temps réel des statistiques (Total, Actifs, Résolus, Critiques) et calcul dynamique du Risk Score local.
- 🚨 **Signalement d'Incidents** : Formulaire intuitif avec géolocalisation GPS, compression/redimensionnement d'images, et calcul déterministe automatique de la priorité.
- ⚡ **Offline-First & Auto-Sync** : Stockage SQLite local (`sqflite`). Tout signalement effectué hors-ligne est sauvegardé et synchronisé automatiquement dès le retour du réseau via `SyncService`.
- 🗺️ **Carte Interactive & Zones à Risque** : Intégration `flutter_map` avec tuiles OpenStreetMap, marqueurs colorés par priorité et cercles thermiques des zones à risque critiques.
- ⏱️ **Détail & Timeline** : Suivi du statut de chaque incident (`REPORTED`, `ACKNOWLEDGED`, `IN_PROGRESS`, `RESOLVED`, `CANCELLED`) avec historique chronologique.
- 🔔 **Notifications** : Alertes locales pour les mises à jour importantes.
- 🌐 **i18n & Accessibilité** : Support dynamique Français / Anglais, mode sombre/clair, et compatibilité avec les lecteurs d'écran (Material 3 Semantics).

---

## 🛠️ Tech Stack

- **Framework** : Flutter 3.47.5 / Dart 3.13.4
- **State Management** : Flutter Riverpod 2.6.1
- **Routing** : GoRouter 14.8.1 (ShellRoute avec Bottom Navigation)
- **Backend & Auth** : Supabase Flutter SDK
- **Base de données Locale** : SQLite (`sqflite`)
- **Cartographie** : `flutter_map` + `latlong2`
- **Géolocalisation** : `geolocator`
- **Compression Média** : `image_picker` + `flutter_image_compress`
- **Localisation** : Official Flutter `flutter_localizations` & `intl` (ARB files)

---

## 📂 Project Structure

```
lib/
├── core/
│   ├── constants/       # Enums, AppConstants, AppColors
│   ├── errors/          # Sealed AppException hierarchy
│   ├── router/          # GoRouter with Auth Guards & ShellRoute
│   ├── theme/           # Material 3 Light & Dark themes
│   ├── utils/           # LocalDatabase, SyncService, ImageHelper, LocationHelper
│   └── widgets/         # AppStateWidgets (Loading, Error, Empty, Offline Banner)
│
├── features/
│   ├── auth/            # AuthRepository, LoginScreen, RegisterScreen, Providers
│   ├── incidents/       # IncidentModel, IncidentRepository, Dashboard, Create & Detail Screens
│   ├── map/             # MapScreen (OpenStreetMap + Risk Zones + Markers)
│   ├── notifications/   # NotificationService & NotificationsScreen
│   └── profile/         # ProfileScreen (i18n, Theme mode, Accessibility)
│
└── main.dart            # Entry point with ProviderScope, i18n & SyncService init
```

---

## ⚙️ Environment Variables & Setup

Cloner le projet et créer les variables d'environnement via `--dart-define` :

```bash
# 1. Obtenir les dépendances
flutter pub get

# 2. Générer les fichiers de localisation
flutter gen-l10n

# 3. Lancer l'application
flutter run --dart-define=SUPABASE_URL=https://your-project.supabase.co --dart-define=SUPABASE_ANON_KEY=your-anon-key
```

---

## 🧪 Tests & Quality Assurance

L'application respecte des standards stricts de qualité sans aucun warning ni erreur statique :

```bash
# Analyse statique
flutter analyze

# Suite de tests (Unit & Widget)
flutter test

# Test d'intégration E2E
flutter test integration_test/app_test.dart
```

---

## 📦 CI/CD Pipeline

Un pipeline GitHub Actions est configuré dans `.github/workflows/flutter.yml` pour :
1. Valider `flutter analyze`
2. Exécuter la suite complète de `flutter test`
3. Compiler le build de production Android APK `--release`

---

## 📄 License

Distribué sous la licence MIT. Voir `LICENSE` pour plus d'informations.
