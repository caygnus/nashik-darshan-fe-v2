import 'package:dio/dio.dart';

class DioClient {
  final Dio _dio;

  DioClient({String? baseUrl})
      : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl ?? 'https://smart-society-backend-2.onrender.com',
            // connectTimeout: const Duration(seconds: 5),
            // receiveTimeout: const Duration(seconds: 5),
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
}
