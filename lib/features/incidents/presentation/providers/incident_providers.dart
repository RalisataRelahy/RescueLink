import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rescuelink/core/constants/enums.dart';
import 'package:rescuelink/core/utils/local_database.dart';
import 'package:rescuelink/features/incidents/data/incident_repository.dart';
import 'package:rescuelink/features/incidents/domain/incident_history_model.dart';
import 'package:rescuelink/features/incidents/domain/incident_model.dart';

final localDatabaseProvider = Provider<LocalDatabase>((ref) {
  return LocalDatabase();
});

final incidentRepositoryProvider = Provider<IncidentRepository>((ref) {
  return IncidentRepository(localDb: ref.watch(localDatabaseProvider));
});

final incidentListProvider =
    FutureProvider.family<List<IncidentModel>, ({IncidentCategory? category, IncidentPriority? priority})>(
        (ref, filters) async {
  final repo = ref.watch(incidentRepositoryProvider);
  return repo.getIncidents(category: filters.category, priority: filters.priority);
});

final incidentHistoryProvider =
    FutureProvider.family<List<IncidentHistoryModel>, String>((ref, incidentId) async {
  final repo = ref.watch(incidentRepositoryProvider);
  return repo.getIncidentHistory(incidentId);
});
