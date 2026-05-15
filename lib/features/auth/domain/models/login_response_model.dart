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

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    final bool success = json['success'] ?? false;

    if (success && json.containsKey('mfaToken')) {
      return LoginResponseModel(
        isSuccess: true,
        message: json['message'] ?? "Check your email for the login code",
        mfaToken: json['mfaToken'],
      );
    } else if (success && json.containsKey('accessToken')) {
      return LoginResponseModel(
        isSuccess: true,
        tokens: AuthTokenModel.fromJson(json),
      );
    }

    return LoginResponseModel(
      isSuccess: false,
      message: json['message'] ?? "Login Failed",
    );
  }
}
