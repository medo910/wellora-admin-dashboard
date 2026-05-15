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
    final body = {
      "email": email.trim(),
      "password": password.trim(),
      "otpCode": otpCode ?? "",
      "usePasskey": false,
    };
    log("Login Request Body: $body");
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
    return await _apiService.get(endpoint: 'auth/token-status-v2');
  }

  Future<Map<String, dynamic>> resendOtp({required String mfaToken}) async {
    final body = {"mfaToken": mfaToken};
    final response = await _apiService.post(endpoint: 'mfa/resend', body: body);
    return response;
  }
}
