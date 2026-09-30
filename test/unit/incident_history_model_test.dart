import 'package:flutter_test/flutter_test.dart';
import 'package:rescuelink/core/constants/enums.dart';
import 'package:rescuelink/features/incidents/domain/incident_history_model.dart';

void main() {
  group('IncidentHistoryModel Unit Tests', () {
    test('toJson and fromJson symmetry for incident history', () {
      final now = DateTime.now();
      final history = IncidentHistoryModel(
        id: 'hist-1',
        incidentId: 'inc-10',
        status: IncidentStatus.inProgress,
        updatedAt: now,
        comment: 'Emergency responders dispatched',
      );

      final json = history.toJson();
      final parsed = IncidentHistoryModel.fromJson(json);

      expect(parsed.id, 'hist-1');
      expect(parsed.incidentId, 'inc-10');
      expect(parsed.status, IncidentStatus.inProgress);
      expect(parsed.comment, 'Emergency responders dispatched');
    });
  });
}
