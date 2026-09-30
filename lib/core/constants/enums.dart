enum IncidentCategory {
  accident,
  fire,
  flood,
  roadBlocked,
  danger,
  water,
  lighting,
  other;

  static IncidentCategory fromString(String v) =>
      IncidentCategory.values.firstWhere((e) => e.name == v,
          orElse: () => IncidentCategory.other);
}

enum IncidentPriority {
  low,
  medium,
  high,
  critical;

  static IncidentPriority fromString(String v) =>
      IncidentPriority.values.firstWhere((e) => e.name == v,
          orElse: () => IncidentPriority.low);
}

enum IncidentStatus {
  reported,
  acknowledged,
  inProgress,
  resolved,
  cancelled;

  static IncidentStatus fromString(String v) =>
      IncidentStatus.values.firstWhere((e) => e.name == v,
          orElse: () => IncidentStatus.reported);
}

enum SyncStatus {
  pending,
  synced,
  failed;

  static SyncStatus fromString(String v) =>
      SyncStatus.values.firstWhere((e) => e.name == v,
          orElse: () => SyncStatus.pending);
}
