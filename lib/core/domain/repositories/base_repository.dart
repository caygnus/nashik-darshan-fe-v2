import 'package:fpdart/fpdart.dart';
import 'package:nashik/core/error/failures/server_failure.dart';
import 'package:nashik/core/utils/result.dart';

/// Base repository interface
/// All repository interfaces should extend this for consistency
abstract class BaseRepository {
  /// Handle errors and convert exceptions to failures
  /// This is a helper method that can be used by repository implementations
  Result<T> handleError<T>(Object error) {
    return Left(
      ServerFailure(
        message: 'An unexpected error occurred: ${error.toString()}',
        code: 'UNEXPECTED_ERROR',
      ),
    );
  }
}
