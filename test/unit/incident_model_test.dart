import 'package:flutter_test/flutter_test.dart';
import 'package:rescuelink/core/constants/enums.dart';
import 'package:rescuelink/features/incidents/domain/incident_model.dart';

void main() {
  group('IncidentModel Unit Tests', () {
    test('toJson and fromJson should be symmetric', () {
      final now = DateTime.now();
      final incident = IncidentModel(
        id: 'inc-123',
        userId: 'user-456',
        category: IncidentCategory.accident,
        description: 'Multi-car collision on main avenue',
        latitude: 48.8566,
        longitude: 2.3522,
        priority: IncidentPriority.high,
        status: IncidentStatus.reported,
        createdAt: now,
        peopleAffected: 4,
        roadBlocked: true,
      );

      final json = incident.toJson();
      final parsed = IncidentModel.fromJson(json);

      expect(parsed.id, incident.id);
      expect(parsed.category, incident.category);
      expect(parsed.priority, incident.priority);
      expect(parsed.roadBlocked, true);
      expect(parsed.peopleAffected, 4);
    });

    test('toLocalDbJson and fromJson local DB compatibility', () {
      final incident = IncidentModel(
        id: 'inc-999',
        userId: 'user-777',
        category: IncidentCategory.flood,
        description: 'Severe water burst',
        latitude: 45.0,
        longitude: 5.0,
        priority: IncidentPriority.critical,
        status: IncidentStatus.inProgress,
        createdAt: DateTime.parse('2026-09-27T12:00:00Z'),
        localPhotoPath: '/tmp/photo.jpg',
        syncStatus: SyncStatus.pending,
      );

      final localJson = incident.toLocalDbJson();
      final parsed = IncidentModel.fromJson(localJson);

      expect(parsed.syncStatus, SyncStatus.pending);
      expect(parsed.localPhotoPath, '/tmp/photo.jpg');
    });

    test('copyWith updates properties correctly', () {
      final incident = IncidentModel(
        id: 'inc-1',
        userId: 'u-1',
        category: IncidentCategory.fire,
        description: 'Original description',
        latitude: 10.0,
        longitude: 20.0,
        priority: IncidentPriority.medium,
        status: IncidentStatus.reported,
        createdAt: DateTime.now(),
      );

      final updated = incident.copyWith(
        status: IncidentStatus.resolved,
        description: 'Updated description',
        syncStatus: SyncStatus.synced,
      );

      expect(updated.id, 'inc-1');
      expect(updated.status, IncidentStatus.resolved);
      expect(updated.description, 'Updated description');
      expect(updated.syncStatus, SyncStatus.synced);
    });

    test('default syncStatus should be synced when created without explicit syncStatus', () {
      final incident = IncidentModel(
        id: 'inc-2',
        userId: 'u-2',
        category: IncidentCategory.water,
        description: 'Pipe leak',
        latitude: 0.0,
        longitude: 0.0,
        priority: IncidentPriority.low,
        status: IncidentStatus.reported,
        createdAt: DateTime.now(),
      );

      expect(incident.syncStatus, SyncStatus.synced);
      expect(incident.peopleAffected, 0);
      expect(incident.roadBlocked, false);
    });
  });
}
