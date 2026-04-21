// lib/features/auth/data/models/login_response_model.dart

import 'package:admin_dashboard_graduation_project/features/auth/domain/models/auth_token_model.dart';

class LoginResponseModel {
  final bool isSuccess;
  final String? message;
  final String? mfaToken;
  final AuthTokenModel? tokens;

  LoginResponseModel({
    required this.isSuccess,
    this.message,
    this.mfaToken,
    this.tokens,
  });

  // factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
  //   final bool success = json['isSuccess'] ?? json['success'] ?? false;
  //   final data = json['data'];

  //   // الحالة 1: محتاجين OTP (موجود mfaToken)
  //   if (success && data != null && data.containsKey('mfaToken')) {
  //     return LoginResponseModel(
  //       isSuccess: true,
  //       message: data['message'] ?? "OTP Sent",
  //       mfaToken: data['mfaToken'],
  //     );
  //   }
  //   // الحالة 2: تسجيل دخول كامل (موجود accessToken)
  //   else if (success && data != null && data.containsKey('accessToken')) {
  //     return LoginResponseModel(
  //       isSuccess: true,
  //       tokens: AuthTokenModel.fromJson(data),
  //     );
  //   }

  //   // الحالة 3: خطأ في تسجيل الدخول
  //   return LoginResponseModel(
  //     isSuccess: false,
  //     message: json['error'] ?? "Login Failed",
  //   );
  // }
  // lib/features/auth/data/models/login_response_model.dart

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    // الباك إند عندك بيبعت "success" مش "isSuccess"
    final bool success = json['success'] ?? false;

    // الحالة 1: محتاجين OTP (الباك إند باعت mfaToken مباشرة في الـ json)
    if (success && json.containsKey('mfaToken')) {
      return LoginResponseModel(
        isSuccess: true,
        message: json['message'] ?? "Check your email for the login code",
        mfaToken: json['mfaToken'],
      );
    }
    // الحالة 2: تسجيل دخول كامل (لو باعت accessToken مباشرة)
    else if (success && json.containsKey('accessToken')) {
      return LoginResponseModel(
        isSuccess: true,
        tokens: AuthTokenModel.fromJson(json), // خليه يقرأ من الـ json نفسه
      );
    }

    // الحالة 3: فشل
    return LoginResponseModel(
      isSuccess: false,
      message: json['message'] ?? "Login Failed",
    );
  }
}
