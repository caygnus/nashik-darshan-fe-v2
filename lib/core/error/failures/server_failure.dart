import 'package:nashik/core/error/failures/failure.dart';

/// Failure representing server/API errors
class ServerFailure extends Failure {
  final int? statusCode;
  final dynamic data;

  const ServerFailure({
    required super.message,
    super.code,
    this.statusCode,
    this.data,
  });

  @override
  List<Object?> get props => [super.props, statusCode, data];
}
