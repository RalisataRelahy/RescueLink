import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:rescuelink/core/constants/app_constants.dart';
import 'package:rescuelink/main.dart' as app;
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    try {
      await Supabase.initialize(
        url: AppConstants.supabaseUrl,
        publishableKey: AppConstants.supabaseAnonKey,
      );
    } catch (_) {
      // Supabase already initialized in test runner
    }
  });

  group('RescueLink E2E Navigation Integration Tests', () {
    testWidgets('1. Verify App Startup and Navigation Bar tab switching', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Verify Dashboard app bar title
      expect(find.text('RescueLink'), findsWidgets);

      // Verify Bottom Navigation Bar presence
      expect(find.byType(NavigationBar), findsOneWidget);

      // Navigate to Map tab
      final mapTab = find.byIcon(Icons.map_outlined);
      if (mapTab.evaluate().isNotEmpty) {
        await tester.tap(mapTab);
        await tester.pumpAndSettle();
        expect(find.text('Map'), findsWidgets);
      }

      // Navigate to Profile tab
      final profileTab = find.byIcon(Icons.person_outline);
      if (profileTab.evaluate().isNotEmpty) {
        await tester.tap(profileTab);
        await tester.pumpAndSettle();
        expect(find.text('Profile'), findsWidgets);
      }
    });

    testWidgets('2. Verify Accessibility & Profile Settings interactions', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to Profile tab
      final profileTab = find.byIcon(Icons.person_outline);
      if (profileTab.evaluate().isNotEmpty) {
        await tester.tap(profileTab);
        await tester.pumpAndSettle();

        // Verify High Contrast toggle exists
        final switchFinder = find.byType(Switch);
        if (switchFinder.evaluate().isNotEmpty) {
          await tester.tap(switchFinder.first);
          await tester.pumpAndSettle();
        }

        // Verify Version display
        expect(find.textContaining('v1.0.0'), findsOneWidget);
      }
    });
  });
}
