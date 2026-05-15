part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

class AuthInitial extends AuthState {}

class LoginLoading extends AuthState {}

class LoginSuccess extends AuthState {
  final AuthEntity user;
  LoginSuccess(this.user);
}

class LoginOtpRequired extends AuthState {
  final String mfaToken;
  final String message;
  LoginOtpRequired({required this.mfaToken, required this.message});
}

class LoginFailure extends AuthState {
  final String errMessage;
  LoginFailure(this.errMessage);
}

class ResendOtpSuccess extends AuthState {
  final String message;
  ResendOtpSuccess({required this.message});
}
