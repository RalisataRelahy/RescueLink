import 'package:flutter_test/flutter_test.dart';
import 'package:rescuelink/core/errors/app_exception.dart';

void main() {
  group('AppException Unit Tests', () {
    test('NetworkException holds correct message and type', () {
      const ex = NetworkException('No internet connection');

      expect(ex, isA<AppException>());
      expect(ex.message, 'No internet connection');
    });

    test('AppAuthException default and custom message', () {
      const defaultEx = AppAuthException();
      const customEx = AppAuthException('Invalid credentials');

      expect(defaultEx.message, 'Authentication error');
      expect(customEx.message, 'Invalid credentials');
    });

    test('ValidationException holds custom validation message', () {
      const ex = ValidationException('Invalid GPS coordinates');

      expect(ex.message, 'Invalid GPS coordinates');
    });

    test('LocalStorageException and PermissionException instantiation', () {
      const storageEx = LocalStorageException('Database corrupted');
      const permEx = PermissionException('Location permission denied');

      expect(storageEx.message, 'Database corrupted');
      expect(permEx.message, 'Location permission denied');
    });
  });
}
