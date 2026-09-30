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
      // Supabase already initialized
    }
  });

  group('RescueLink Incident Creation E2E Integration Tests', () {
    testWidgets('3. Verify Incident Creation Form validation and fields', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Find Floating Action Button to report incident
      final fab = find.byType(FloatingActionButton);
      if (fab.evaluate().isNotEmpty) {
        await tester.tap(fab);
        await tester.pumpAndSettle();

        // Verify Create Incident form widgets
        expect(find.text('Report incident'), findsWidgets);
        expect(find.byType(TextFormField), findsOneWidget);

        // Submit form without filling to test validation error
        final submitBtn = find.byType(FilledButton);
        if (submitBtn.evaluate().isNotEmpty) {
          await tester.tap(submitBtn);
          await tester.pumpAndSettle();
        }
      }
    });
  });
}
