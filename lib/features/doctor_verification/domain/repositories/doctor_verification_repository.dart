import 'package:admin_dashboard_graduation_project/core/errors/failures.dart';
import 'package:admin_dashboard_graduation_project/features/doctor_verification/domain/entities/doctor_verification_entity.dart';
import 'package:admin_dashboard_graduation_project/features/doctor_verification/domain/entities/paginated_result.dart';
import 'package:admin_dashboard_graduation_project/features/doctor_verification/domain/entities/verification_stats_entity.dart';
import 'package:dartz/dartz.dart';

abstract class DoctorVerificationRepository {
  Future<Either<Failure, PaginatedResult<DoctorVerificationEntity>>>
  getVerifications({
    int page = 1,
    int pageSize = 10,
    String? status,
    String? fromDate,
    String? toDate,
  });

  Future<Either<Failure, String>> approveVerification(
    int doctorId,
    String? adminNotes,
  );

  Future<Either<Failure, String>> rejectVerification({
    required int doctorId,
    required String reason,
    String? adminNotes,
  });

  Future<Either<Failure, VerificationStatsEntity>> getStatistics();
}
