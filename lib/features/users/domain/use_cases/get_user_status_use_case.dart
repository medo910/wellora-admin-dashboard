// lib/features/users/domain/use_cases/get_user_status_use_case.dart

import 'package:admin_dashboard_graduation_project/core/errors/failures.dart';
import 'package:admin_dashboard_graduation_project/features/users/domain/entities/user_status_details_entity.dart';
import 'package:admin_dashboard_graduation_project/features/users/domain/repositories/users_repository.dart';
import 'package:dartz/dartz.dart';

class GetUserStatusUseCase {
  final UsersRepository repository;
  GetUserStatusUseCase(this.repository);

  Future<Either<Failure, UserStatusDetailsEntity>> call(int userId) {
    return repository.getUserStatus(userId);
  }
}
