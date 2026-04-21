import 'package:admin_dashboard_graduation_project/core/errors/failures.dart';
import 'package:admin_dashboard_graduation_project/features/users/data/models/user_response_model.dart';
import 'package:admin_dashboard_graduation_project/features/users/domain/repositories/users_repository.dart';
import 'package:dartz/dartz.dart';

class GetUsersUseCase {
  final UsersRepository repository;
  GetUsersUseCase(this.repository);

  Future<Either<Failure, UserResponseModel>> call({
    int doctorsPage = 1,
    int patientsPage = 1,
    String? searchTerm,
  }) {
    return repository.getUsers(
      doctorsPage: doctorsPage,
      patientsPage: patientsPage,
      searchTerm: searchTerm,
    );
  }
}
