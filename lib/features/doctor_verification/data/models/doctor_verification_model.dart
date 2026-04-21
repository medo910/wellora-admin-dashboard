// lib/features/doctor_verification/data/models/doctor_verification_model.dart
import '../../domain/entities/doctor_verification_entity.dart';
import 'verification_document_model.dart';

// class DoctorVerificationModel extends DoctorVerificationEntity {
//   DoctorVerificationModel({
//     required super.doctorId,
//     required super.doctorName,
//     required super.doctorEmail,
//     required super.specialization,
//     super.phoneNumber,
//     super.clinicLocation,
//     super.yearsOfExperience,
//     required super.overallStatus,
//     required super.submittedAt,
//     required super.documents,
//   });

//   factory DoctorVerificationModel.fromJson(Map<String, dynamic> json) {
//     return DoctorVerificationModel(
//       doctorId: json['doctorId'],
//       doctorName: json['doctorName'],
//       doctorEmail: json['doctorEmail'],
//       phoneNumber: json['phoneNumber'], // نزل فعلاً في الجيسون
//       specialization: json['specialization'],
//       clinicLocation: json['clinicLocation'], // نزل فعلاً (موجود في إبراهيم)
//       yearsOfExperience: json['yearsOfExperience'], // نزل فعلاً
//       // 💡 شيلنا الـ overallStatus لأن الباك مبعتهاش، ممكن نحسبها إحنا أو نمسحها
//       overallStatus: "Pending",
//       submittedAt:
//           json['verifications'][0]['submittedAt'], // هناخد تاريخ أول ورقة كمرجع
//       // ✅ التعديل هنا: اسم الكي بقى "verifications"
//       documents: (json['verifications'] as List)
//           .map((doc) => VerificationDocumentModel.fromJson(doc))
//           .toList(),
//     );
//   }
// }

// lib/features/doctor_verification/data/models/doctor_verification_model.dart

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
      // 💡 استخدمنا 'requestStatus' اللي جاية من الباك إند
      overallStatus: json['requestStatus'] ?? "Pending",
      // سحبنا تاريخ التقديم من أول ورقة موجودة
      submittedAt:
          (json['verifications'] != null && json['verifications'].isNotEmpty)
          ? json['verifications'][0]['submittedAt']
          : DateTime.now().toIso8601String(),
      documents:
          (json['verifications'] as List?)
              ?.map((doc) => VerificationDocumentModel.fromJson(doc))
              .toList() ??
          [],
    );
  }
}
