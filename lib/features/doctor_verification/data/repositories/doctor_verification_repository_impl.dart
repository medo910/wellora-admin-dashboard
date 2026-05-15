import 'package:admin_dashboard_graduation_project/features/doctor_verification/domain/entities/doctor_verification_entity.dart';
import 'package:admin_dashboard_graduation_project/features/doctor_verification/domain/entities/paginated_result.dart';
import 'package:admin_dashboard_graduation_project/features/doctor_verification/domain/entities/verification_stats_entity.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/repositories/doctor_verification_repository.dart';
import '../data_sources/doctor_verification_remote_data_source.dart';

class DoctorVerificationRepositoryImpl implements DoctorVerificationRepository {
  final DoctorVerificationRemoteDataSource remoteDataSource;
  DoctorVerificationRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, PaginatedResult<DoctorVerificationEntity>>>
  getVerifications({
    int page = 1,
    int pageSize = 10,
    String? status,
    String? fromDate,
    String? toDate,
  }) async {
    try {
      final queryParams = {
        "page": page,
        "pageSize": pageSize,
        if (status != null) "status": status,
        if (fromDate != null) "fromDate": fromDate,
        if (toDate != null) "toDate": toDate,
      };

      final result = await remoteDataSource.getVerifications(queryParams);

      return Right(
        PaginatedResult(
          data: result.doctors,
          totalCount: result.totalCount,
          hasNextPage: result.hasNextPage,
          currentPage: result.page,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> approveVerification(
    int doctorId,
    String? adminNotes,
  ) async {
    try {
      final response = await remoteDataSource.approveVerification(
        doctorId,
        adminNotes,
      );
      return Right(response['message'] ?? "Approved successfully");
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> rejectVerification({
    required int doctorId,
    required String reason,
    String? adminNotes,
  }) async {
    try {
      final response = await remoteDataSource.rejectVerification(
        doctorId,
        reason,
        adminNotes,
      );
      return Right(response['message'] ?? "Rejected successfully");
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, VerificationStatsEntity>> getStatistics() async {
    try {
      final result = await remoteDataSource.getStatistics();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
