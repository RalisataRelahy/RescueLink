class UserProfileModel {
  const UserProfileModel({
    required this.id,
    required this.email,
    this.fullName,
    this.avatarUrl,
    this.language = 'fr',
  });

  final String id;
  final String email;
  final String? fullName;
  final String? avatarUrl;
  final String language;

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'full_name': fullName,
        'avatar_url': avatarUrl,
        'language': language,
      };

  factory UserProfileModel.fromJson(Map<String, dynamic> json) => UserProfileModel(
        id: json['id'] as String,
        email: json['email'] as String? ?? '',
        fullName: json['full_name'] as String?,
        avatarUrl: json['avatar_url'] as String?,
        language: json['language'] as String? ?? 'fr',
      );
}
