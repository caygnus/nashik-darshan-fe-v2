import 'package:nashik/core/error/failures/failure.dart';

/// Failure representing input validation errors
class ValidationFailure extends Failure {
  final Map<String, String>? errors;

  const ValidationFailure({required super.message, super.code, this.errors});

  factory ValidationFailure.invalidInput(String field) {
    return ValidationFailure(
      message: 'Invalid input for field: $field',
      code: 'INVALID_INPUT',
      errors: {field: 'Invalid input'},
    );
  }

  factory ValidationFailure.missingField(String field) {
    return ValidationFailure(
      message: 'Required field is missing: $field',
      code: 'MISSING_FIELD',
      errors: {field: 'This field is required'},
    );
  }

  @override
  List<Object?> get props => [super.props, errors];
}
