// lib/features/doctor_verification/domain/entities/doctor_verification_entity.dart

import 'verification_document_entity.dart';

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
  // 💡 هنا لستة الوثائق اللي الباك إند هيجمعها
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
  });

  String get computedStatus {
    if (documents.any((d) => d.status == "Pending")) return "Pending";
    if (documents.any((d) => d.status == "Approved")) return "Approved";
    if (documents.any((d) => d.status == "Rejected")) return "Rejected";
    return "Pending";
  }
}
