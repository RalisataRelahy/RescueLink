import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rescuelink/features/auth/presentation/providers/auth_provider.dart';
import 'package:rescuelink/features/profile/presentation/profile_screen.dart';
import 'package:rescuelink/generated/l10n/app_localizations.dart';

void main() {
  Widget wrapWidget(Widget widget) {
    return ProviderScope(
      overrides: [
        currentUserProvider.overrideWith((ref) => null),
      ],
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

  group('ProfileScreen Widget Tests', () {
    testWidgets('ProfileScreen renders user section, language, theme and high contrast options', (tester) async {
      await tester.pumpWidget(wrapWidget(const ProfileScreen()));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.language), findsOneWidget);
      expect(find.byIcon(Icons.brightness_6), findsOneWidget);
      expect(find.byIcon(Icons.accessibility_new), findsOneWidget);
      expect(find.text('RescueLink v1.0.0+1'), findsOneWidget);
    });
  });
}
