import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rescuelink/features/incidents/data/incident_repository.dart';
import 'package:rescuelink/features/incidents/presentation/providers/incident_providers.dart';

class SyncService {
  SyncService({
    required this.repository,
    Connectivity? connectivity,
  }) : _connectivity = connectivity ?? Connectivity();

  final IncidentRepository repository;
  final Connectivity _connectivity;
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  void initialize() {
    _subscription?.cancel();
    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      final isOnline = !results.contains(ConnectivityResult.none);
      if (isOnline) {
        syncPending();
      }
    });
  }

  Future<void> syncPending() async {
    await repository.syncPendingIncidents();
  }

  void dispose() {
    _subscription?.cancel();
  }
}

final syncServiceProvider = Provider<SyncService>((ref) {
  final repo = ref.watch(incidentRepositoryProvider);
  final syncService = SyncService(repository: repo);
  syncService.initialize();
  ref.onDispose(() => syncService.dispose());
  return syncService;
});
