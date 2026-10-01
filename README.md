# RescueLink 

[![CI/CD Pipeline](https://github.com/RalisataRelahy/RescueLink/actions/workflows/flutter.yml/badge.svg)](https://github.com/RalisataRelahy/RescueLink/actions)
[![Flutter](https://img.shields.io/badge/Flutter-3.47.5-blue)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.13.4-blue)](https://dart.dev)
[![Tests](https://img.shields.io/badge/Tests-32%20passed-brightgreen)](#-tests--quality-assurance)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

**RescueLink** est une application Flutter production-ready de signalement et de suivi d'incidents communautaires, conçue pour être **offline-first**, **accessible (a11y)**, **haute performance (60 FPS constant)** et **internationalisée (FR / EN)**.

**Repository GitHub Public** : [https://github.com/RalisataRelahy/RescueLink.git](https://github.com/RalisataRelahy/RescueLink.git)

---

## Captures d'écran & Aperçu Visuel (Visual Showcase)

| Dashboard & Risk Score |  Signalement d'Incident |                                       🗺 Carte Interactive                                       | ⚙️ Profil & Accessibilité |
| :---: | :---: |:------------------------------------------------------------------------------------------------:| :---: |
| ![Dashboard](https://raw.githubusercontent.com/RalisataRelahy/RescueLink/main/doc/screenshots/dashboard.png) | ![Report](https://raw.githubusercontent.com/RalisataRelahy/RescueLink/main/doc/screenshots/create_incident.png) | ![Map](https://raw.githubusercontent.com/RalisataRelahy/RescueLink/main/doc/screenshots/map.png) | ![Profile](https://raw.githubusercontent.com/RalisataRelahy/RescueLink/main/doc/screenshots/profile.png) |
| *Calcul dynamique du Score de Risque local et compteurs en temps réel* | *Géolocalisation GPS, compression d'image et priorité déterministe* |                  *Tuiles OpenStreetMap, marqueurs colorés et cercles de risque*                  | *Sélecteur i18n (FR/EN), thème Clair/Sombre et Mode Haute Lisibilité* |

---

## Liste des Écrans (8 Écrans Fonctionnels)

1. **Dashboard (`DashboardScreen`)** : Vue globale avec score de risque local (0-100), statistiques d'incidents (Total, Actifs, Résolus, Critiques) et fil d'actualité des récents signalements.
2. **Liste des Incidents (`IncidentsScreen`)** : Feed filtrable par statut et catégorie avec pull-to-refresh et indicateurs de synchronisation hors-ligne.
3. **Signalement d'Incident (`CreateIncidentScreen`)** : Formulaire interactif avec capture GPS, sélecteur photo + compression automatique, et calcul déterministe de la priorité.
4. **Détail & Timeline (`IncidentDetailScreen`)** : Vue détaillée d'un incident avec photo HD, localisation exacte et suivi de l'historique chronologique des statuts.
5. **Carte Interactive (`MapScreen`)** : Cartographie `flutter_map` avec marqueurs personnalisés par priorité, filtres de catégories et cercles de zones critiques.
6. **Notifications (`NotificationsScreen`)** : Centre de notifications retraçant la réception, la prise en charge et la résolution des signalements.
7. **Profil & Configuration (`ProfileScreen`)** : Gestion du profil utilisateur, basculement de langue en direct (FR/EN), sélecteur de thème et Mode Haute Lisibilité.
8. **Authentification (`LoginScreen` / `RegisterScreen`)** : Flux d'authentification Supabase avec validation de formulaire et Route Guards (`GoRouter`).

---

## Performances & Optimisations (60 FPS Constant)

- **Zéro Jank (60fps Constant)** : Utilisation exclusive de `ListView.builder` et `ListView.separated` pour le lazy-loading dynamique des listes, garantissant un défilement fluide sans saccades.
- **Optimisation & Compression d'Images** : Pipeline `ImageHelper` utilisant `flutter_image_compress` pour redimensionner et compresser les photos localement (qualité moyenne, résolution adaptée) avant tout stockage ou upload réseau.
- **Rebuilds Minimalistes** : Utilisation ciblée de Flutter Riverpod avec sélecteurs réactifs (`ref.watch`) et emploi de constructeurs `const` sur tous les widgets immuables afin d'éliminer les recompositions inutiles de l'arbre de widgets.

---

## Accessibilité (Accessibility & A11y)

- **Semantic Labels & Screen Readers** : Tous les éléments interactifs (boutons, cartes d'incidents, champs de texte) sont enveloppés dans des widgets `Semantics` avec descriptions localisées (`semanticIncidentCard`, `semanticBackButton`).
- **Mode Haute Lisibilité (High Contrast Mode)** : Toggle dédié dans l'écran de profil ajustant dynamiquement les ratios de contraste des couleurs.
- **Material 3 Standards** : Respect des zones de frappe minimales (48x48 dp) et support de la taille de texte dynamique du système.

---

## Internationalisation (i18n)

- **Multi-langue dynamique (Français / English)** : Fichiers ARB d'origine (`app_fr.arb`, `app_en.arb`) compilés via `flutter gen-l10n`.
- **Changement à la volée** : Le basculement de langue s'effectue instantanément depuis le profil grâce à `localeProvider` sans redémarrer l'application.

---

## Tests & Quality Assurance

L'application est couverte par une suite complète de **32 tests automatisés** :

### Breakdown de la couverture de tests :
- **19 Tests Unitaires** (`test/unit/`) :
  - Algorithme déterministe de priorité (`PriorityCalculator`).
  - Sérialisation / Désérialisation et `copyWith` des modèles (`IncidentModel`, `UserProfileModel`, `IncidentHistoryModel`).
  - Hiérarchie scellée des exceptions applicatives (`AppException`).
- **10 Tests de Widgets** (`test/widget/`) :
  - Composants d'état applicatifs (`AppLoadingIndicator`, `AppErrorWidget`, `AppEmptyWidget`, `AppOfflineBanner`).
  - Composant carte d'incident (`IncidentCard`).
  - Formulaires et écrans (`LoginScreen`, `NotificationsScreen`, `ProfileScreen`).
- **3 Tests d'Intégration E2E** (`integration_test/`) :
  - Test 1 : Lancement de l'application et navigation complète via la `NavigationBar`.
  - Test 2 : Paramètres de profil, basculement de thème et basculement Haute Lisibilité.
  - Test 3 : Formulaire de signalement d'incident et validation de la priorité.

```bash
# 1. Analyse statique (0 warnings, 0 errors)
flutter analyze

# 2. Exécution des tests unitaires et de widgets avec couverture
flutter test --coverage

# 3. Exécution des tests d'intégration E2E
flutter test integration_test/
```

---

## CI/CD Pipeline (GitHub Actions)

Le pipeline `.github/workflows/flutter.yml` s'exécute automatiquement sur chaque push et PR :

1. **Static Analysis** : Valide `flutter analyze`.
2. **Unit & Widget Testing** : Lance `flutter test --coverage`.
3. **Integration Testing** : Exécute les tests E2E via un runner headless Linux (`xvfb-run --auto-servernum flutter test integration_test/`).
4. **Release Build** : Génère l'APK Android de production (`flutter build apk --release`).

---

##  Configuration & Lancement

```bash
# 1. Obtenir les dépendances
flutter pub get

# 2. Générer les fichiers de localisation
flutter gen-l10n

# 3. Lancer l'application avec les clés Supabase
flutter run --dart-define=SUPABASE_URL=https://your-project.supabase.co --dart-define=SUPABASE_ANON_KEY=your-anon-key
```

---

## License

Distribué sous la licence MIT. Voir `LICENSE` pour plus d'informations.
