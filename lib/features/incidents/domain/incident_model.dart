import 'package:rescuelink/core/constants/enums.dart';

class IncidentModel {
  const IncidentModel({
    required this.id,
    required this.userId,
    required this.category,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.priority,
    required this.status,
    required this.createdAt,
    this.photoUrl,
    this.localPhotoPath,
    this.syncStatus = SyncStatus.synced,
    this.peopleAffected = 0,
    this.roadBlocked = false,
  });

  final String id;
  final String userId;
  final IncidentCategory category;
  final String description;
  final double latitude;
  final double longitude;
  final IncidentPriority priority;
  final IncidentStatus status;
  final DateTime createdAt;
  final String? photoUrl;
  final String? localPhotoPath;
  final SyncStatus syncStatus;
  final int peopleAffected;
  final bool roadBlocked;

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'category': category.name,
        'description': description,
        'latitude': latitude,
        'longitude': longitude,
        'priority': priority.name,
        'status': status.name,
        'created_at': createdAt.toIso8601String(),
        'photo_url': photoUrl,
        'people_affected': peopleAffected,
        'road_blocked': roadBlocked ? 1 : 0,
      };

  Map<String, dynamic> toLocalDbJson() => {
        ...toJson(),
        'local_photo_path': localPhotoPath,
        'sync_status': syncStatus.name,
      };

  factory IncidentModel.fromJson(Map<String, dynamic> json) => IncidentModel(
        id: json['id'] as String,
        userId: json['user_id'] as String? ?? 'anonymous',
        category: IncidentCategory.fromString(json['category'] as String),
        description: json['description'] as String,
        latitude: (json['latitude'] as num).toDouble(),
        longitude: (json['longitude'] as num).toDouble(),
        priority: IncidentPriority.fromString(json['priority'] as String),
        status: IncidentStatus.fromString(json['status'] as String),
        createdAt: DateTime.parse(json['created_at'] as String),
        photoUrl: json['photo_url'] as String?,
        localPhotoPath: json['local_photo_path'] as String?,
        syncStatus: SyncStatus.fromString(json['sync_status'] as String? ?? 'synced'),
        peopleAffected: (json['people_affected'] as num?)?.toInt() ?? 0,
        roadBlocked: json['road_blocked'] == 1 || json['road_blocked'] == true,
      );

  IncidentModel copyWith({
    String? id,
    String? userId,
    IncidentCategory? category,
    String? description,
    double? latitude,
    double? longitude,
    IncidentPriority? priority,
    IncidentStatus? status,
    DateTime? createdAt,
    String? photoUrl,
    String? localPhotoPath,
    SyncStatus? syncStatus,
    int? peopleAffected,
    bool? roadBlocked,
  }) {
    return IncidentModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      category: category ?? this.category,
      description: description ?? this.description,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      photoUrl: photoUrl ?? this.photoUrl,
      localPhotoPath: localPhotoPath ?? this.localPhotoPath,
      syncStatus: syncStatus ?? this.syncStatus,
      peopleAffected: peopleAffected ?? this.peopleAffected,
      roadBlocked: roadBlocked ?? this.roadBlocked,
    );
  }
}
