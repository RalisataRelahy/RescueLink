import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rescuelink/core/constants/enums.dart';
import 'package:rescuelink/features/incidents/domain/incident_model.dart';
import 'package:rescuelink/features/incidents/presentation/providers/incident_providers.dart';

class DashboardStats {
  const DashboardStats({
    required this.total,
    required this.active,
    required this.resolved,
    required this.critical,
    required this.riskScore,
    required this.recentIncidents,
  });

  final int total;
  final int active;
  final int resolved;
  final int critical;
  final int riskScore; // 0 - 100
  final List<IncidentModel> recentIncidents;
}

final dashboardStatsProvider = FutureProvider<DashboardStats>((ref) async {
  final repo = ref.watch(incidentRepositoryProvider);
  final incidents = await repo.getIncidents(page: 0, limit: 100);

  final total = incidents.length;
  int active = 0;
  int resolved = 0;
  int critical = 0;

  for (final inc in incidents) {
    if (inc.status == IncidentStatus.resolved ||
        inc.status == IncidentStatus.cancelled) {
      resolved++;
    } else {
      active++;
    }

    if (inc.priority == IncidentPriority.critical) {
      critical++;
    }
  }

  // Calculate local risk score based on active critical/high incidents
  int rawRiskScore = 0;
  for (final inc in incidents) {
    if (inc.status == IncidentStatus.resolved || inc.status == IncidentStatus.cancelled) {
      continue;
    }
    switch (inc.priority) {
      case IncidentPriority.critical:
        rawRiskScore += 25;
        break;
      case IncidentPriority.high:
        rawRiskScore += 15;
        break;
      case IncidentPriority.medium:
        rawRiskScore += 8;
        break;
      case IncidentPriority.low:
        rawRiskScore += 3;
        break;
    }
  }

  final riskScore = rawRiskScore.clamp(0, 100);
  final recent = incidents.take(5).toList();

  return DashboardStats(
    total: total,
    active: active,
    resolved: resolved,
    critical: critical,
    riskScore: riskScore,
    recentIncidents: recent,
  );
});
