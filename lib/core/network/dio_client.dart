import 'package:dio/dio.dart';

import '../config/env.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/logging_interceptor.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  late final Dio _dio;

  factory DioClient() => _instance;

  DioClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: Env.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'accept': 'application/json',
          'Authorization': 'Bearer ${Env.accessToken}',
        },
      ),
    );

    // [SOLID] Open/Closed Principle (OCP):
    // The client is open for extension (adding new interceptors like Alice or Logging)
    // but closed for modification of its core request logic.
    _dio.interceptors.addAll([LoggingInterceptor(), ErrorInterceptor()]);
  }

  Dio get dio => _dio;
}
