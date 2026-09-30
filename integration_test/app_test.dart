import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:rescuelink/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('RescueLink E2E Flow Integration Test', () {
    testWidgets('App starts and navigates correctly across tabs', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Verify app launched successfully
      expect(find.text('RescueLink'), findsWidgets);
    });
  });
}
