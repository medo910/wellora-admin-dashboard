// lib/features/users/domain/repositories/users_repository.dart

import 'package:admin_dashboard_graduation_project/features/users/domain/entities/user_status_details_entity.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/user_response_model.dart';

abstract class UsersRepository {
  Future<Either<Failure, UserResponseModel>> getUsers({
    int doctorsPage = 1,
    int patientsPage = 1,
    String? searchTerm,
  });

  Future<Either<Failure, Unit>> blockUser({
    required int userId,
    required String reason,
  });
  Future<Either<Failure, Unit>> unblockUser({required int userId});
  Future<Either<Failure, Unit>> suspendUser({
    required int userId,
    required String reason,
    required String endDate,
  });
  Future<Either<Failure, Unit>> unsuspendUser({required int userId});
  Future<Either<Failure, UserStatusDetailsEntity>> getUserStatus(int userId);
}
