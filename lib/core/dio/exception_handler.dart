import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:nashik/core/error/exception.dart';

Future<T> performSafeOperation<T>(Future<T> Function() operation) async {
  try {
    return await operation();
  } on DioException catch (e) {
    log(e.error.toString());
    Map data = e.response?.data;
    throw ServerException(message: data['errorMsg'] ?? 'Dio error occurred');
  } catch (e) {
    log(e.toString());
    throw ServerException(message: e.toString());
  }
}
