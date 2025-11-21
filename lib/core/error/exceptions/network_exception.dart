import 'package:nashik/core/error/exceptions/app_exception.dart';

/// Exception thrown when network connectivity issues occur
class NetworkException extends AppException {
  const NetworkException({required super.message, super.code});

  factory NetworkException.noInternet() {
    return const NetworkException(
      message: 'No internet connection. Please check your network settings.',
      code: 'NO_INTERNET',
    );
  }

  factory NetworkException.timeout() {
    return const NetworkException(
      message: 'Connection timeout. Please check your internet connection.',
      code: 'TIMEOUT',
    );
  }

  factory NetworkException.connectionError() {
    return const NetworkException(
      message: 'Connection error. Please try again later.',
      code: 'CONNECTION_ERROR',
    );
  }
}
