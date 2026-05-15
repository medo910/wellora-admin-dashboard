import 'dart:developer';

import 'package:admin_dashboard_graduation_project/core/di/secure_storage_helper.dart';
import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await SecureStorageHelper.getAccessToken();

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    log('➡️ [REQUEST] ${options.method} ${options.path}');
    return handler.next(options);
  }
}
