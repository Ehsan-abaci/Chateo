class AppException implements Exception {
  final String message;
  final String? code;

  AppException({required this.message, this.code});
}

class NetworkException extends AppException {
  final int? statusCode;

  NetworkException({
    required super.message,
    this.statusCode,
    super.code,
  });

  factory NetworkException.fromStatusCode(int statusCode, [String? message]) {
    switch (statusCode) {
      case 400:
        return NetworkException(
          message: 'Bad request',
          statusCode: statusCode,
          code: 'BAD_REQUEST',
        );
      case 422:
        return NetworkException(
          message: message ?? 'Error!',
        );
      default:
        return NetworkException(
          message: 'Network error occured',
          statusCode: statusCode,
          code: 'NETWORK_ERROR',
        );
    }
  }
}
