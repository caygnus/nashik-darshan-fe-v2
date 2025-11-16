import 'package:nashik/core/domain/repositories/base_repository.dart';
import 'package:nashik/core/utils/result.dart';
import 'package:nashik/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:nashik/features/auth/data/datasources/auth_supabase_datasource.dart';
import 'package:nashik/features/auth/data/models/signup_request_model.dart';
import 'package:nashik/features/auth/data/models/update_user_request_model.dart';
import 'package:nashik/features/auth/data/models/user_model.dart';
import 'package:nashik/features/auth/domain/dtos/signup_request.dart';
import 'package:nashik/features/auth/domain/dtos/signup_response.dart';
import 'package:nashik/features/auth/domain/dtos/update_user_request.dart';
import 'package:nashik/features/auth/domain/entities/user.dart';
import 'package:nashik/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl extends BaseRepository implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthSupabaseDataSource supabaseDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.supabaseDataSource,
  });

  @override
  Future<Result<SignupResponse>> signup(SignupRequest request) async {
    return executeWithErrorHandling<SignupResponse>(() async {
      // Convert domain DTO to data model for API call
      final requestModel = SignupRequestModel(
        email: request.email,
        phone: request.phone,
        name: request.name,
        accessToken: request.accessToken,
      );

      // Call backend API with Supabase access token
      final responseModel = await remoteDataSource.signup(requestModel);

      // Convert data model to domain DTO
      return SignupResponse(
        id: responseModel.id,
        accessToken: responseModel.accessToken,
      );
    });
  }

  @override
  Future<Result<User>> getCurrentUser() async {
    return executeWithErrorHandling<User>(() async {
      final userModel = await remoteDataSource.getCurrentUser();
      return userModel.toEntity();
    });
  }

  @override
  Future<Result<User>> updateUser(UpdateUserRequest request) async {
    return executeWithErrorHandling<User>(() async {
      // Convert domain DTO to data model for API call
      final requestModel = UpdateUserRequestModel(
        name: request.name,
        phone: request.phone,
      );

      final userModel = await remoteDataSource.updateUser(requestModel);
      return userModel.toEntity();
    });
  }
}
