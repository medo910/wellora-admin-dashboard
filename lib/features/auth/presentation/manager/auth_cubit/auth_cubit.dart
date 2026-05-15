import 'package:admin_dashboard_graduation_project/features/auth/domain/entities/auth_entity.dart';
import 'package:admin_dashboard_graduation_project/features/auth/domain/entities/login_result_entity.dart';
import 'package:admin_dashboard_graduation_project/features/auth/domain/use_cases/login_use_case.dart';
import 'package:admin_dashboard_graduation_project/features/auth/domain/use_cases/resend_otp_use_case.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase _loginUseCase;
  final ResendOtpUseCase _resendOtpUseCase;

  AuthCubit(this._loginUseCase, this._resendOtpUseCase) : super(AuthInitial());

  Future<void> login({
    required String email,
    required String password,
    String? otpCode,
  }) async {
    emit(LoginLoading());

    final result = await _loginUseCase.call(email, password, otpCode: otpCode);

    result.fold((failure) => emit(LoginFailure(failure.errmessage)), (
      loginResult,
    ) {
      if (loginResult is LoginOtpRequiredEntity) {
        emit(
          LoginOtpRequired(
            mfaToken: loginResult.mfaToken,
            message: loginResult.message,
          ),
        );
      } else if (loginResult is LoginSuccessEntity) {
        emit(LoginSuccess(loginResult.user));
      }
    });
  }

  Future<void> resendOtp(String mfaToken) async {
    final result = await _resendOtpUseCase.call(mfaToken);

    result.fold(
      (failure) => emit(LoginFailure(failure.errmessage)),
      (response) =>
          emit(ResendOtpSuccess(message: response["message"] ?? "OTP Sent")),
    );
  }
}
