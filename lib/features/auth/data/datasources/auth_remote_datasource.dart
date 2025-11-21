import 'package:dio/dio.dart';
import 'package:nashik/core/dio/config.dart';
import 'package:nashik/core/error/exceptions/app_exception.dart';
import 'package:nashik/core/error/exceptions/server_exception.dart';
import 'package:nashik/features/auth/data/models/signup_request_model.dart';
import 'package:nashik/features/auth/data/models/signup_response_model.dart';
import 'package:nashik/features/auth/data/models/update_user_request_model.dart';
import 'package:nashik/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<SignupResponseModel> signup(SignupRequestModel request);
  Future<UserModel> getCurrentUser();
  Future<UserModel> updateUser(UpdateUserRequestModel request);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient dioClient;

  AuthRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<SignupResponseModel> signup(SignupRequestModel request) async {
    try {
      final response = await dioClient.post<Map<String, dynamic>>(
        '/auth/signup',
        data: request.toJson(),
      );
      return SignupResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException {
      rethrow;
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException(
        message: 'Failed to sign up: ${e.toString()}',
        code: 'UNEXPECTED_ERROR',
      );
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await dioClient.get<Map<String, dynamic>>('/user/me');
      return UserModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException {
      rethrow;
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException(
        message: 'Failed to get current user: ${e.toString()}',
        code: 'UNEXPECTED_ERROR',
      );
    }
  }

  @override
  Future<UserModel> updateUser(UpdateUserRequestModel request) async {
    try {
      final response = await dioClient.put<Map<String, dynamic>>(
        '/user',
        data: request.toJson(),
      );
      return UserModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException {
      rethrow;
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException(
        message: 'Failed to update user: ${e.toString()}',
        code: 'UNEXPECTED_ERROR',
      );
    }
  }
}
