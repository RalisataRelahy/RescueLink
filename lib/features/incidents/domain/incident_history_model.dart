import 'package:rescuelink/core/constants/enums.dart';

class IncidentHistoryModel {
  const IncidentHistoryModel({
    required this.id,
    required this.incidentId,
    required this.status,
    required this.updatedAt,
    this.comment,
  });

  final String id;
  final String incidentId;
  final IncidentStatus status;
  final DateTime updatedAt;
  final String? comment;

  Map<String, dynamic> toJson() => {
        'id': id,
        'incident_id': incidentId,
        'status': status.name,
        'updated_at': updatedAt.toIso8601String(),
        'comment': comment,
      };

  factory IncidentHistoryModel.fromJson(Map<String, dynamic> json) => IncidentHistoryModel(
        id: json['id'] as String,
        incidentId: json['incident_id'] as String,
        status: IncidentStatus.fromString(json['status'] as String),
        updatedAt: DateTime.parse(json['updated_at'] as String),
        comment: json['comment'] as String?,
      );
}
