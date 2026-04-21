// lib/core/network/auth_interceptor.dart
import 'package:admin_dashboard_graduation_project/core/di/secure_storage_helper.dart';
import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // جلب التوكن من السكيور ستورج [cite: 90, 98]
    final token = await SecureStorageHelper.getAccessToken();

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token'; // [cite: 84]
    }

    print('➡️ [REQUEST] ${options.method} ${options.path}');
    return handler.next(options);
  }
}
