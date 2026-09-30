import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rescuelink/features/notifications/presentation/notifications_screen.dart';
import 'package:rescuelink/generated/l10n/app_localizations.dart';

void main() {
  Widget wrapWidget(Widget widget) {
    return ProviderScope(
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        home: widget,
      ),
    );
  }

  group('NotificationsScreen Widget Tests', () {
    testWidgets('NotificationsScreen renders title and list of notifications', (tester) async {
      await tester.pumpWidget(wrapWidget(const NotificationsScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Notifications'), findsOneWidget);
      expect(find.byType(ListTile), findsNWidgets(2));
      expect(find.byIcon(Icons.notifications_active_outlined), findsNWidgets(2));
    });
  });
}
