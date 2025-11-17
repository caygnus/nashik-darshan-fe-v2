import 'package:dio/dio.dart';

class DioClient {
  final Dio _dio;

  DioClient({String? baseUrl})
    : _dio = Dio(
        BaseOptions(
          baseUrl:
              baseUrl ??
              const String.fromEnvironment(
                'API_BASE_URL',
                defaultValue: 'https://smart-society-backend-2.onrender.com',
              ),

          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );

  Dio get dio => _dio;

  Future<Response> getRequest(String endpoint) async {
    try {
      Response response = await _dio.get(endpoint);
      return response;
    } on DioException catch (e) {
      throw Exception('Failed to load data: ${e.message}');
    }
  }

  Future<Response> postRequest(String endpoint, dynamic data) async {
    try {
      return await _dio.post(endpoint, data: data);
    } on DioException catch (e) {
      throw Exception('Failed to post data: ${e.message}');
    }
  }

  Future<Response> putRequest(String endpoint, dynamic data) async {
    try {
      return await _dio.put(endpoint, data: data);
    } on DioException catch (e) {
      throw Exception('Failed to update data: ${e.message}');
    }
  }

  Future<Response> deleteRequest(String endpoint) async {
    try {
      return await _dio.delete(endpoint);
    } on DioException catch (e) {
      throw Exception('Failed to delete data: ${e.message}');
    }
  }
}
