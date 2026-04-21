import 'package:admin_dashboard_graduation_project/core/errors/failures.dart';
import 'package:admin_dashboard_graduation_project/features/doctor_verification/domain/repositories/doctor_verification_repository.dart';
import 'package:dartz/dartz.dart';

class ApproveVerificationUseCase {
  final DoctorVerificationRepository repository;
  ApproveVerificationUseCase(this.repository);

  Future<Either<Failure, String>> call(int doctorId, String? adminNotes) {
    return repository.approveVerification(doctorId, adminNotes);
  }
}
