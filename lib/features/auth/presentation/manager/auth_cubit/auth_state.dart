part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

class AuthInitial extends AuthState {}

class LoginLoading extends AuthState {}

// حالة النجاح النهائي (الدخول للداشبورد)
class LoginSuccess extends AuthState {
  final AuthEntity user;
  LoginSuccess(this.user);
}

// حالة طلب الـ OTP (الانتقال لصفحة الكود)
class LoginOtpRequired extends AuthState {
  final String mfaToken;
  final String message;
  LoginOtpRequired({required this.mfaToken, required this.message});
}

// حالة الفشل
class LoginFailure extends AuthState {
  final String errMessage;
  LoginFailure(this.errMessage);
}

// حالة نجاح إعادة إرسال الـ OTP
class ResendOtpSuccess extends AuthState {
  final String message;
  ResendOtpSuccess({required this.message});
}
