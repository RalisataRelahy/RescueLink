import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rescuelink/features/auth/presentation/providers/auth_provider.dart';
import 'package:rescuelink/features/auth/presentation/login_screen.dart';
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

  group('LoginScreen Widget Tests', () {
    testWidgets('LoginScreen renders logo, form fields and submit button', (tester) async {
      await tester.pumpWidget(wrapWidget(const LoginScreen()));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.shield_outlined), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.byType(FilledButton), findsOneWidget);
    });

    testWidgets('Submitting empty login form displays validation error messages', (tester) async {
      await tester.pumpWidget(wrapWidget(const LoginScreen()));
      await tester.pumpAndSettle();

      final loginBtn = find.byType(FilledButton);
      await tester.tap(loginBtn);
      await tester.pumpAndSettle();

      expect(find.text('Something went wrong'), findsNWidgets(2));
    });
  });
}
