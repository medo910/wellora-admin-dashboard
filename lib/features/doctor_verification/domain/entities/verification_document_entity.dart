class VerificationDocumentEntity {
  final int verificationId;
  final String documentType;
  final String fileUrl;
  final String status;
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
