import 'package:nashik/core/error/exceptions/app_exception.dart';

/// Exception thrown when server/API returns an error
class ServerException extends AppException {
  final int? statusCode;
  final dynamic data;

  const ServerException({
    required super.message,
    super.code,
    this.statusCode,
    this.data,
  });

  @override
  String toString() {
    if (statusCode != null) {
      return 'ServerException: $message (Status: $statusCode)';
    }
    return 'ServerException: $message';
  }
}
