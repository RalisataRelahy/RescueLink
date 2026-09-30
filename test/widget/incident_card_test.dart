import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rescuelink/core/constants/enums.dart';
import 'package:rescuelink/features/incidents/domain/incident_model.dart';
import 'package:rescuelink/features/incidents/presentation/widgets/incident_card.dart';
import 'package:rescuelink/generated/l10n/app_localizations.dart';

void main() {
  testWidgets('IncidentCard renders description, category and status chip correctly',
      (WidgetTester tester) async {
    final incident = IncidentModel(
      id: 'inc-1',
      userId: 'user-1',
      category: IncidentCategory.fire,
      description: 'Building fire reported on 5th street',
      latitude: 48.0,
      longitude: 2.0,
      priority: IncidentPriority.critical,
      status: IncidentStatus.reported,
      createdAt: DateTime.now(),
    );

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        home: Scaffold(
          body: IncidentCard(incident: incident),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Building fire reported on 5th street'), findsOneWidget);
    expect(find.text('reported'), findsOneWidget);
    expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
  });
}
