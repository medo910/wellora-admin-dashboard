import 'package:admin_dashboard_graduation_project/core/di/secure_storage_helper.dart';
import 'package:dio/dio.dart';

class RefreshTokenInterceptor extends Interceptor {
  final Dio _dio;
  RefreshTokenInterceptor(this._dio);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final refreshToken = await SecureStorageHelper.getRefreshToken();
      final accessToken = await SecureStorageHelper.getAccessToken();

      if (refreshToken != null && accessToken != null) {
        try {
          final refreshDio = Dio(BaseOptions(baseUrl: _dio.options.baseUrl));

          final response = await refreshDio.post(
            'auth/refresh-token',
            data: {"accessToken": accessToken, "refreshToken": refreshToken},
          );

          if (response.statusCode == 200 &&
              response.data['isSuccess'] == true) {
            final newAccess = response.data['data']['accessToken'];
            final newRefresh = response.data['data']['refreshToken'];

            await SecureStorageHelper.updateTokens(
              newAccessToken: newAccess,
              newRefreshToken: newRefresh,
            );

            err.requestOptions.headers['Authorization'] = 'Bearer $newAccess';
            final clonedRequest = await _dio.fetch(err.requestOptions);
            return handler.resolve(clonedRequest);
          }
        } catch (e) {
          await SecureStorageHelper.clearAll();
        }
      }
    }
    return handler.next(err);
  }
}
