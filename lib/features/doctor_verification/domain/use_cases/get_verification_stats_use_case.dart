import 'package:admin_dashboard_graduation_project/core/errors/failures.dart';
import 'package:admin_dashboard_graduation_project/features/doctor_verification/domain/entities/verification_stats_entity.dart';
import 'package:admin_dashboard_graduation_project/features/doctor_verification/domain/repositories/doctor_verification_repository.dart';
import 'package:dartz/dartz.dart';

class GetVerificationStatsUseCase {
  final DoctorVerificationRepository repository;
  GetVerificationStatsUseCase(this.repository);

  Future<Either<Failure, VerificationStatsEntity>> call() {
    return repository.getStatistics();
  }
}
