import 'package:admin_dashboard_graduation_project/core/errors/failures.dart';
import 'package:admin_dashboard_graduation_project/features/users/domain/repositories/users_repository.dart';
import 'package:dartz/dartz.dart';

class BlockUserUseCase {
  final UsersRepository repository;
  BlockUserUseCase(this.repository);
  Future<Either<Failure, Unit>> call(int id, String reason) =>
      repository.blockUser(userId: id, reason: reason);
}
