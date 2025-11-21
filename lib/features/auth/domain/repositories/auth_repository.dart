import 'package:nashik/core/domain/repositories/base_repository.dart';
import 'package:nashik/core/utils/result.dart';
import 'package:nashik/features/auth/domain/dtos/signup_request.dart';
import 'package:nashik/features/auth/domain/dtos/signup_response.dart';
import 'package:nashik/features/auth/domain/dtos/update_user_request.dart';
import 'package:nashik/features/auth/domain/entities/user.dart';

abstract class AuthRepository extends BaseRepository {
  /// Sign up a new user with Supabase access token
  /// First signs up with Supabase, then calls backend API with access token
  Future<Result<SignupResponse>> signup(SignupRequest request);

  /// Get current authenticated user
  Future<Result<User>> getCurrentUser();

  /// Update current user information
  Future<Result<User>> updateUser(UpdateUserRequest request);
}
