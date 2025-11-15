import 'package:nashik/core/error/exceptions/app_exception.dart';

/// Exception thrown when input validation fails
class ValidationException extends AppException {
  final Map<String, String>? errors;

  const ValidationException({required super.message, super.code, this.errors});

  factory ValidationException.invalidInput(String field) {
    return ValidationException(
      message: 'Invalid input for field: $field',
      code: 'INVALID_INPUT',
      errors: {field: 'Invalid input'},
    );
  }

  factory ValidationException.missingField(String field) {
    return ValidationException(
      message: 'Required field is missing: $field',
      code: 'MISSING_FIELD',
      errors: {field: 'This field is required'},
    );
  }
}
