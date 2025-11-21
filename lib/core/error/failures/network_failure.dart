import 'package:nashik/core/error/failures/failure.dart';

/// Failure representing network connectivity issues
class NetworkFailure extends Failure {
  const NetworkFailure({required super.message, super.code});

  factory NetworkFailure.noInternet() {
    return const NetworkFailure(
      message: 'No internet connection. Please check your network settings.',
      code: 'NO_INTERNET',
    );
  }

  factory NetworkFailure.timeout() {
    return const NetworkFailure(
      message: 'Connection timeout. Please check your internet connection.',
      code: 'TIMEOUT',
    );
  }

  factory NetworkFailure.connectionError() {
    return const NetworkFailure(
      message: 'Connection error. Please try again later.',
      code: 'CONNECTION_ERROR',
    );
  }
}
