// lib/features/auth/data/data_sources/auth_remote_data_source.dart
import 'dart:developer';

import 'package:admin_dashboard_graduation_project/core/network/api_service.dart';

class AuthRemoteDataSource {
  final ApiService _apiService;
  AuthRemoteDataSource(this._apiService);

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    String? otpCode,
  }) async {
    // البادي المطلوب بناءً على توضيحك [cite: 73]
    final body = {
      "email": email.trim(),
      "password": password.trim(),
      "otpCode": otpCode ?? "",
      "usePasskey": false,
    };
    log("Login Request Body: $body"); // لوج للتأكد من البادي قبل الإرسال
    // نداء إيند بوينت الـ Auth/login [cite: 146, 217]
    return await _apiService.post(endpoint: 'Auth/login', body: body);
  }

  Future<void> logout({required int userId, required String jti}) async {
    await _apiService.post(
      endpoint: 'Auth/logout',
      body: {"userId": userId, "jti": jti},
    );
  }

  Future<Map<String, dynamic>> refreshToken({
    required String refreshToken,
    required String accessToken,
  }) async {
    final body = {"refreshToken": refreshToken, "accessToken": accessToken};
    final response = await _apiService.post(
      endpoint: 'auth/refresh-token',
      body: body,
    );
    return response;
  }

  Future<Map<String, dynamic>> checkToken() async {
    return await _apiService.get(
      endpoint: 'auth/token-status-v2',
      // bearerToken: accessToken,
    );
  }

  Future<Map<String, dynamic>> resendOtp({required String mfaToken}) async {
    final body = {"mfaToken": mfaToken};
    final response = await _apiService.post(endpoint: 'mfa/resend', body: body);
    return response;
  }
}
