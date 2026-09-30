import 'package:flutter_test/flutter_test.dart';
import 'package:rescuelink/features/auth/domain/user_profile_model.dart';

void main() {
  group('UserProfileModel Unit Tests', () {
    test('fromJson converts json map to UserProfileModel correctly', () {
      final json = {
        'id': 'user-100',
        'email': 'test@rescuelink.org',
        'full_name': 'Jane Doe',
        'avatar_url': 'https://example.com/avatar.png',
        'language': 'en',
      };

      final profile = UserProfileModel.fromJson(json);

      expect(profile.id, 'user-100');
      expect(profile.email, 'test@rescuelink.org');
      expect(profile.fullName, 'Jane Doe');
      expect(profile.avatarUrl, 'https://example.com/avatar.png');
      expect(profile.language, 'en');
    });

    test('toJson produces expected map output', () {
      const profile = UserProfileModel(
        id: 'user-200',
        email: 'user@rescuelink.org',
        fullName: 'John Smith',
        language: 'fr',
      );

      final json = profile.toJson();

      expect(json['id'], 'user-200');
      expect(json['email'], 'user@rescuelink.org');
      expect(json['full_name'], 'John Smith');
      expect(json['language'], 'fr');
      expect(json['avatar_url'], isNull);
    });

    test('fromJson provides fallback defaults for optional fields', () {
      final json = {'id': 'user-300'};

      final profile = UserProfileModel.fromJson(json);

      expect(profile.id, 'user-300');
      expect(profile.email, '');
      expect(profile.fullName, isNull);
      expect(profile.language, 'fr');
    });
  });
}
