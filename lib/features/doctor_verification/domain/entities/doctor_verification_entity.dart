import 'package:admin_dashboard_graduation_project/features/doctor_verification/domain/entities/verification_document_entity.dart';

class DoctorVerificationEntity {
  final int doctorId;
  final String doctorName;
  final String doctorEmail;
  final String specialization;
  final String? phoneNumber;
  final String? clinicLocation;
  final int? yearsOfExperience;
  final String overallStatus;
  final String submittedAt;
  final bool isReadyForReview;
  final List<String> missingRequiredDocuments;
  final String? rejectionReason;
  final String? adminNotes;
  final String? reviewedByAdminName;
  final List<VerificationDocumentEntity> documents;

  DoctorVerificationEntity({
    required this.doctorId,
    required this.doctorName,
    required this.doctorEmail,
    required this.specialization,
    this.phoneNumber,
    this.clinicLocation,
    this.yearsOfExperience,
    required this.overallStatus,
    required this.submittedAt,
    required this.documents,
    required this.isReadyForReview,
    required this.missingRequiredDocuments,
    this.rejectionReason,
    this.adminNotes,
    this.reviewedByAdminName,
  });
}
