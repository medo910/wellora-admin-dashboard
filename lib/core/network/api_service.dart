import 'package:admin_dashboard_graduation_project/core/network/auth_interceptor.dart';
import 'package:admin_dashboard_graduation_project/core/network/refresh_token_interceptor.dart';
import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio;

  ApiService()
    : _dio = Dio(
        BaseOptions(
          baseUrl:
              'https://nonvolitional-unstuccoed-wilfred.ngrok-free.dev/api/',
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          headers: {
            'Content-Type': 'application/json',
            'ngrok-skip-browser-warning': 'true',
          },
        ),
      ) {
    _dio.interceptors.addAll([
      AuthInterceptor(),
      RefreshTokenInterceptor(_dio),
      LogInterceptor(responseBody: true, requestBody: true),
    ]);
  }

  Future<dynamic> get({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await _dio.get(endpoint, queryParameters: queryParameters);
    return response.data;
  }

  Future<dynamic> post({required String endpoint, dynamic body}) async {
    final response = await _dio.post(endpoint, data: body);
    return response.data;
  }

  Future<dynamic> patch({required String endpoint, dynamic data}) async {
    final response = await _dio.patch(endpoint, data: data);
    return response.data;
  }

  Future<dynamic> put({required String endpoint, dynamic data}) async {
    final response = await _dio.put(endpoint, data: data);
    return response.data;
  }
}
