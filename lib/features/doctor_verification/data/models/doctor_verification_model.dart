import '../../domain/entities/doctor_verification_entity.dart';
import 'verification_document_model.dart';

class DoctorVerificationModel extends DoctorVerificationEntity {
  DoctorVerificationModel({
    required super.doctorId,
    required super.doctorName,
    required super.doctorEmail,
    required super.specialization,
    super.phoneNumber,
    super.clinicLocation,
    super.yearsOfExperience,
    required super.overallStatus,
    required super.submittedAt,
    required super.documents,
    required super.isReadyForReview,
    required super.missingRequiredDocuments,
    super.rejectionReason,
    super.adminNotes,
    super.reviewedByAdminName,
  });

  factory DoctorVerificationModel.fromJson(Map<String, dynamic> json) {
    return DoctorVerificationModel(
      doctorId: json['doctorId'],
      doctorName: json['doctorName'] ?? "N/A",
      doctorEmail: json['doctorEmail'] ?? "N/A",
      phoneNumber: json['phoneNumber'],
      specialization: json['specialization'] ?? "General",
      clinicLocation: json['clinicLocation'],
      yearsOfExperience: json['yearsOfExperience'] ?? 0,

      overallStatus: json['requestStatus'] ?? "Pending",

      submittedAt: json['submittedAt'] ?? DateTime.now().toIso8601String(),

      isReadyForReview: json['isReadyForReview'] ?? false,
      missingRequiredDocuments: List<String>.from(
        json['missingRequiredDocuments'] ?? [],
      ),
      rejectionReason: json['rejectionReason'],
      adminNotes: json['adminNotes'],
      reviewedByAdminName: json['reviewedByAdminName'],

      documents:
          (json['verifications'] as List?)
              ?.map((doc) => VerificationDocumentModel.fromJson(doc))
              .toList() ??
          [],
    );
  }
}
