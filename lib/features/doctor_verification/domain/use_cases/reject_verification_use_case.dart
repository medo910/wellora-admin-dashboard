import 'package:admin_dashboard_graduation_project/core/errors/failures.dart';
import 'package:admin_dashboard_graduation_project/features/doctor_verification/domain/repositories/doctor_verification_repository.dart';
import 'package:dartz/dartz.dart';

class RejectVerificationUseCase {
  final DoctorVerificationRepository repository;
  RejectVerificationUseCase(this.repository);

  Future<Either<Failure, String>> call({
    required int doctorId,
    required String reason,
    String? adminNotes,
  }) {
    return repository.rejectVerification(
      doctorId: doctorId,
      reason: reason,
      adminNotes: adminNotes,
    );
  }
}
