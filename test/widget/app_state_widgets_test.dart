import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rescuelink/core/widgets/app_state_widgets.dart';
import 'package:rescuelink/generated/l10n/app_localizations.dart';

void main() {
  Widget wrapWidget(Widget widget) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      home: Scaffold(body: widget),
    );
  }

  group('AppStateWidgets Widget Tests', () {
    testWidgets('AppLoadingIndicator renders CircularProgressIndicator', (tester) async {
      await tester.pumpWidget(wrapWidget(const AppLoadingIndicator()));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('AppErrorWidget renders message and triggers retry callback when pressed', (tester) async {
      var retried = false;
      await tester.pumpWidget(
        wrapWidget(
          AppErrorWidget(
            message: 'Failed to load data from server',
            onRetry: () => retried = true,
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Failed to load data from server'), findsOneWidget);
      expect(find.byType(FilledButton), findsOneWidget);

      await tester.tap(find.byType(FilledButton));
      expect(retried, isTrue);
    });

    testWidgets('AppEmptyWidget renders custom message and icon', (tester) async {
      await tester.pumpWidget(
        wrapWidget(
          const AppEmptyWidget(
            message: 'No active incidents found',
            icon: Icons.search_off,
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('No active incidents found'), findsOneWidget);
      expect(find.byIcon(Icons.search_off), findsOneWidget);
    });

    testWidgets('AppOfflineBanner renders wifi off icon and offline message', (tester) async {
      await tester.pumpWidget(wrapWidget(const AppOfflineBanner()));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.wifi_off), findsOneWidget);
    });
  });
}
