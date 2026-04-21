// lib/features/auth/domain/use_cases/resend_otp_use_case.dart
import 'package:admin_dashboard_graduation_project/core/errors/failures.dart';
import 'package:admin_dashboard_graduation_project/features/auth/domain/repos/auth_repo.dart';
import 'package:dartz/dartz.dart';

class ResendOtpUseCase {
  final AuthRepository repository;
  ResendOtpUseCase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call(String mfaToken) async {
    return await repository.resendOtp(mfaToken: mfaToken); //
  }
}
