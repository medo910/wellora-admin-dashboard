// lib/features/auth/domain/entities/login_result_entity.dart

import 'package:admin_dashboard_graduation_project/features/auth/domain/entities/auth_entity.dart';

abstract class LoginResultEntity {}

/// الحالة الأولى: إرسال الـ OTP بنجاح ومحتاجين ننتقل لصفحة الإدخال
class LoginOtpRequiredEntity extends LoginResultEntity {
  final String mfaToken; // التوكن المطلوب لإتمام العملية
  final String message; // رسالة من الباك إند (مثلاً: تم إرسال الكود لإيميلك)

  LoginOtpRequiredEntity({required this.mfaToken, required this.message});
}

/// الحالة النهائية: نجاح تسجيل الدخول ومعانا بيانات الأدمن
class LoginSuccessEntity extends LoginResultEntity {
  final AuthEntity user; // بيانات الأدمن اللي سجل دخول

  LoginSuccessEntity({required this.user});
}
