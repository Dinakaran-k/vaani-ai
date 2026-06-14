sealed class AppException implements Exception {
  const AppException(this.message, {this.cause});

  final String message;
  final Object? cause;

  @override
  String toString() => 'AppException: $message';
}

final class AuthException extends AppException {
  const AuthException(super.message, {super.cause});
}

final class NetworkException extends AppException {
  const NetworkException(super.message, {super.cause});
}

final class ValidationException extends AppException {
  const ValidationException(super.message, {super.cause});
}

final class AiException extends AppException {
  const AiException(super.message, {super.cause});
}
