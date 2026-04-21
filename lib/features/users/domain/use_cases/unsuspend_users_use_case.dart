import 'package:admin_dashboard_graduation_project/core/errors/failures.dart';
import 'package:admin_dashboard_graduation_project/features/users/domain/repositories/users_repository.dart';
import 'package:dartz/dartz.dart';

class UnsuspendUserUseCase {
  final UsersRepository repository;
  UnsuspendUserUseCase(this.repository);
  Future<Either<Failure, Unit>> call(int id) =>
      repository.unsuspendUser(userId: id);
}
