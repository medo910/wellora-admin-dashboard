// lib/core/network/api_service.dart
import 'package:admin_dashboard_graduation_project/core/network/auth_interceptor.dart';
import 'package:admin_dashboard_graduation_project/core/network/refresh_token_interceptor.dart';
import 'package:dio/dio.dart';

// class ApiService {
//   final Dio _dio;

//   ApiService()
//     : _dio = Dio(
//         BaseOptions(
//           baseUrl:
//               'https://wellora-healthcaremanagment.runasp.net/api/', // الـ Base URL للأدمن [cite: 43]
//           connectTimeout: const Duration(seconds: 30), // [cite: 304]
//           receiveTimeout: const Duration(seconds: 30),
//           headers: {'Content-Type': 'application/json'},
//         ),
//       ) {
//     _dio.interceptors.addAll([
//       AuthInterceptor(),
//       RefreshTokenInterceptor(_dio),
//       LogInterceptor(responseBody: true, requestBody: true), // للـ Debugging
//     ]);
//   }

//   // ميثود عامة للـ GET [cite: 124]
//   Future<dynamic> get(String endpoint, {Map<String, dynamic>? query}) async {
//     final response = await _dio.get(endpoint, queryParameters: query);
//     return response.data;
//   }

//   // ميثود عامة للـ POST [cite: 124]
//   Future<dynamic> post(String endpoint, dynamic data) async {
//     final response = await _dio.post(endpoint, data: data);
//     return response.data;
//   }
// }

// lib/core/network/api_service.dart

class ApiService {
  final Dio _dio;

  ApiService()
    : _dio = Dio(
        BaseOptions(
          baseUrl: 'https://wellora-healthcaremanagment.runasp.net/api/',
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          headers: {'Content-Type': 'application/json'},
        ),
      ) {
    _dio.interceptors.addAll([
      AuthInterceptor(),
      RefreshTokenInterceptor(_dio),
      LogInterceptor(responseBody: true, requestBody: true),
    ]);
  }

  // تعديل: استخدام Named Parameters
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
}
