import 'package:admin_dashboard_graduation_project/core/errors/failures.dart';
import 'package:admin_dashboard_graduation_project/features/users/domain/repositories/users_repository.dart';
import 'package:dartz/dartz.dart';

class SuspendUserUseCase {
  final UsersRepository repository;
  SuspendUserUseCase(this.repository);
  Future<Either<Failure, Unit>> call(int id, String reason, String date) =>
      repository.suspendUser(userId: id, reason: reason, endDate: date);
}
