import 'package:equatable/equatable.dart';

/// Base failure class for all application failures
/// Using abstract class to allow extension in separate files
abstract class Failure extends Equatable {
  final String message;
  final String? code;

  const Failure({required this.message, this.code});

  @override
  List<Object?> get props => [message, code];

  @override
  String toString() => message;
}
