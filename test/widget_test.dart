import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Smoke test for ProviderScope and MaterialApp', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: Center(child: Text('RescueLink')),
          ),
        ),
      ),
    );

    expect(find.text('RescueLink'), findsOneWidget);
  });
}
