sealed class AppException implements Exception {
  const AppException(this.message);
  final String message;
}

final class NetworkException extends AppException {
  const NetworkException([super.message = 'Network error']);
}

final class ServerException extends AppException {
  const ServerException([super.message = 'Server error']);
  final int? statusCode = null;
}

final class AppAuthException extends AppException {
  const AppAuthException([super.message = 'Authentication error']);
}

final class NotFoundException extends AppException {
  const NotFoundException([super.message = 'Resource not found']);
}

final class LocalStorageException extends AppException {
  const LocalStorageException([super.message = 'Local storage error']);
}

final class PermissionException extends AppException {
  const PermissionException([super.message = 'Permission denied']);
}

final class ValidationException extends AppException {
  const ValidationException(super.message);
}
