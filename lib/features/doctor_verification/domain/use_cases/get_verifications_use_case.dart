import 'package:admin_dashboard_graduation_project/features/doctor_verification/domain/entities/paginated_result.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/doctor_verification_entity.dart';
import '../repositories/doctor_verification_repository.dart';

class GetVerificationsUseCase {
  final DoctorVerificationRepository repository;
  GetVerificationsUseCase(this.repository);

  Future<Either<Failure, PaginatedResult<DoctorVerificationEntity>>> call({
    int page = 1,
    int pageSize = 10,
    String? status,
    String? fromDate,
    String? toDate,
  }) {
    return repository.getVerifications(
      page: page,
      pageSize: pageSize,
      status: status,
      fromDate: fromDate,
      toDate: toDate,
    );
  }
}
