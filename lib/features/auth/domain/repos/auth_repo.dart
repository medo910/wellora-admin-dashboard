import 'package:admin_dashboard_graduation_project/core/errors/failures.dart';
import 'package:admin_dashboard_graduation_project/features/auth/domain/entities/login_result_entity.dart';
import 'package:admin_dashboard_graduation_project/features/auth/domain/models/auth_token_model.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  Future<Either<Failure, LoginResultEntity>> login({
    required String email,
    required String password,
    String? otpCode,
  });

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, bool>> checkAccessValidity(String accessToken);
  Future<Either<Failure, AuthTokenModel>> refreshToken({
    required String refreshToken,
    required String accessToken,
  });

  Future<Either<Failure, Map<String, dynamic>>> resendOtp({
    required String mfaToken,
  });
}
