// lib/features/doctor_verification/domain/entities/verification_document_entity.dart

class VerificationDocumentEntity {
  final int verificationId;
  final String documentType;
  final String fileUrl;
  final String status; // Pending, Approved, Rejected
  final String? adminNotes;
  final String? rejectionReason;

  VerificationDocumentEntity({
    required this.verificationId,
    required this.documentType,
    required this.fileUrl,
    required this.status,
    this.adminNotes,
    this.rejectionReason,
  });
}
