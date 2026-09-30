import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:rescuelink/core/constants/enums.dart';
import 'package:rescuelink/core/errors/app_exception.dart';
import 'package:rescuelink/core/utils/local_database.dart';
import 'package:rescuelink/features/incidents/domain/incident_history_model.dart';
import 'package:rescuelink/features/incidents/domain/incident_model.dart';

class IncidentRepository {
  IncidentRepository({
    SupabaseClient? supabase,
    LocalDatabase? localDb,
    Connectivity? connectivity,
  })  : _supabase = supabase ?? Supabase.instance.client,
        _localDb = localDb ?? LocalDatabase(),
        _connectivity = connectivity ?? Connectivity();

  final SupabaseClient _supabase;
  final LocalDatabase _localDb;
  final Connectivity _connectivity;

  Future<bool> _isOnline() async {
    final result = await _connectivity.checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }

  Future<List<IncidentModel>> getIncidents({
    int page = 0,
    int limit = 20,
    IncidentCategory? category,
    IncidentPriority? priority,
  }) async {
    final isOnline = await _isOnline();
    if (!isOnline) {
      return await _localDb.getAllIncidents();
    }

    try {
      var query = _supabase.from('incidents').select();
      if (category != null) {
        query = query.eq('category', category.name);
      }
      if (priority != null) {
        query = query.eq('priority', priority.name);
      }

      final response = await query
          .order('created_at', ascending: false)
          .range(page * limit, (page + 1) * limit - 1);

      final remoteList = (response as List)
          .map((json) => IncidentModel.fromJson(json as Map<String, dynamic>))
          .toList();

      for (final incident in remoteList) {
        await _localDb.saveIncident(incident);
      }

      return remoteList;
    } catch (e) {
      // Fallback to local DB if remote query fails
      return await _localDb.getAllIncidents();
    }
  }

  Future<IncidentModel> createIncident(IncidentModel incident) async {
    final isOnline = await _isOnline();

    if (!isOnline) {
      final pendingIncident = incident.copyWith(syncStatus: SyncStatus.pending);
      await _localDb.saveIncident(pendingIncident);
      return pendingIncident;
    }

    try {
      String? photoUrl = incident.photoUrl;

      // Upload image if present locally
      if (incident.localPhotoPath != null && photoUrl == null) {
        photoUrl = await uploadImage(incident.localPhotoPath!);
      }

      final incidentToUpload = incident.copyWith(
        photoUrl: photoUrl,
        syncStatus: SyncStatus.synced,
      );

      final response = await _supabase
          .from('incidents')
          .insert(incidentToUpload.toJson())
          .select()
          .single();

      final created = IncidentModel.fromJson(response);
      await _localDb.saveIncident(created);

      // Add initial history entry
      await addHistory(created.id, created.status, comment: 'Incident reported');

      return created;
    } catch (e) {
      // Save locally if upload fails
      final pendingIncident = incident.copyWith(syncStatus: SyncStatus.pending);
      await _localDb.saveIncident(pendingIncident);
      return pendingIncident;
    }
  }

  Future<void> syncPendingIncidents() async {
    final isOnline = await _isOnline();
    if (!isOnline) return;

    final pendingList = await _localDb.getUnsyncedIncidents();
    for (final incident in pendingList) {
      try {
        String? photoUrl = incident.photoUrl;
        if (incident.localPhotoPath != null && photoUrl == null) {
          photoUrl = await uploadImage(incident.localPhotoPath!);
        }

        final incidentToSync = incident.copyWith(
          photoUrl: photoUrl,
          syncStatus: SyncStatus.synced,
        );

        await _supabase.from('incidents').insert(incidentToSync.toJson());
        await _localDb.updateSyncStatus(incident.id, SyncStatus.synced,
            remotePhotoUrl: photoUrl);
      } catch (e) {
        await _localDb.updateSyncStatus(incident.id, SyncStatus.failed);
      }
    }
  }

  Future<String?> uploadImage(String filePath) async {
    try {
      final file = File(filePath);
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final path = 'incidents/$fileName';

      await _supabase.storage.from('photos').upload(path, file);
      final publicUrl = _supabase.storage.from('photos').getPublicUrl(path);
      return publicUrl;
    } catch (e) {
      throw ServerException('Failed to upload image: $e');
    }
  }

  Future<List<IncidentHistoryModel>> getIncidentHistory(String incidentId) async {
    try {
      final response = await _supabase
          .from('incident_history')
          .select()
          .eq('incident_id', incidentId)
          .order('updated_at', ascending: true);

      return (response as List)
          .map((json) => IncidentHistoryModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> addHistory(String incidentId, IncidentStatus status, {String? comment}) async {
    try {
      final history = IncidentHistoryModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        incidentId: incidentId,
        status: status,
        updatedAt: DateTime.now(),
        comment: comment,
      );
      await _supabase.from('incident_history').insert(history.toJson());
    } catch (_) {}
  }
}
