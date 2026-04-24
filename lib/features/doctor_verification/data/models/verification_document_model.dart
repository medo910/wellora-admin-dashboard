// lib/features/doctor_verification/data/models/verification_document_model.dart
import '../../domain/entities/verification_document_entity.dart';

class VerificationDocumentModel extends VerificationDocumentEntity {
  VerificationDocumentModel({
    required super.verificationId,
    required super.documentType,
    required super.fileUrl,
    required super.status,
    super.adminNotes,
    super.rejectionReason,
  });

  // factory VerificationDocumentModel.fromJson(Map<String, dynamic> json) {
  //   return VerificationDocumentModel(
  //     verificationId: json['verificationId'],
  //     documentType: json['documentType'],
  //     fileUrl: json['fileUrl'],
  //     status: json['status'],
  //     adminNotes: json['adminNotes'],
  //     rejectionReason: json['rejectionReason'],
  //   );
  // }
  // lib/features/doctor_verification/data/models/verification_document_model.dart

  factory VerificationDocumentModel.fromJson(Map<String, dynamic> json) {
    return VerificationDocumentModel(
      verificationId: json['verificationId'],
      documentType: json['documentType'] ?? "Unknown",
      fileUrl: json['fileUrl'] ?? "",

      // 💡 بما إن الباك إند شالها من هنا، هنديها قيمة افتراضية عشان الكود ميكرشش
      status: json['status'] ?? "Uploaded",

      adminNotes: json['adminNotes'],
      rejectionReason: json['rejectionReason'],
    );
  }
}
