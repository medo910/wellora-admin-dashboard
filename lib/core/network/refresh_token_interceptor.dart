// lib/core/network/refresh_token_interceptor.dart
import 'package:admin_dashboard_graduation_project/core/di/secure_storage_helper.dart';
import 'package:dio/dio.dart';

class RefreshTokenInterceptor extends Interceptor {
  final Dio _dio;
  RefreshTokenInterceptor(this._dio);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // إذا كان الخطأ 401 (انتهت صلاحية التوكن) [cite: 124, 295]
    if (err.response?.statusCode == 401) {
      final refreshToken = await SecureStorageHelper.getRefreshToken();
      final accessToken = await SecureStorageHelper.getAccessToken();

      if (refreshToken != null && accessToken != null) {
        try {
          // نستخدم Dio جديد لطلب الريفرش لتجنب التداخل
          final refreshDio = Dio(BaseOptions(baseUrl: _dio.options.baseUrl));

          final response = await refreshDio.post(
            'auth/refresh-token',
            data: {"accessToken": accessToken, "refreshToken": refreshToken},
          ); // [cite: 93]

          if (response.statusCode == 200 &&
              response.data['isSuccess'] == true) {
            final newAccess = response.data['data']['accessToken'];
            final newRefresh = response.data['data']['refreshToken'];

            // حفظ التوكنز الجديدة [cite: 97]
            await SecureStorageHelper.updateTokens(
              newAccessToken: newAccess,
              newRefreshToken: newRefresh,
            );

            // إعادة المحاولة للطلب الأصلي بالتوكن الجديد
            err.requestOptions.headers['Authorization'] = 'Bearer $newAccess';
            final clonedRequest = await _dio.fetch(err.requestOptions);
            return handler.resolve(clonedRequest);
          }
        } catch (e) {
          // لو الريفرش فشل، سجل خروج ونظف البيانات [cite: 102, 305]
          await SecureStorageHelper.clearAll();
          // هنا ممكن تنادي على الـ GoRouter يحولك للوج إن
        }
      }
    }
    return handler.next(err);
  }
}
