// lib/features/auth/domain/use_cases/login_use_case.dart
import 'package:admin_dashboard_graduation_project/core/errors/failures.dart';
import 'package:admin_dashboard_graduation_project/features/auth/domain/entities/login_result_entity.dart';
import 'package:admin_dashboard_graduation_project/features/auth/domain/repos/auth_repo.dart';
import 'package:dartz/dartz.dart';

class LoginUseCase {
  final AuthRepository repository;
  LoginUseCase(this.repository);

  Future<Either<Failure, LoginResultEntity>> call(
    String email,
    String password, {
    String? otpCode,
  }) async {
    return await repository.login(
      email: email,
      password: password,
      otpCode: otpCode,
    );
  }
}
