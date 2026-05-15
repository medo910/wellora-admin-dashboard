import 'doctor_verification_model.dart';

class DoctorVerificationResponseModel {
  final List<DoctorVerificationModel> doctors;
  final int totalCount;
  final int page;
  final int pageSize;
  final bool hasNextPage;

  DoctorVerificationResponseModel({
    required this.doctors,
    required this.totalCount,
    required this.page,
    required this.pageSize,
    required this.hasNextPage,
  });

  factory DoctorVerificationResponseModel.fromJson(Map<String, dynamic> json) {
    return DoctorVerificationResponseModel(
      doctors: (json['doctors'] as List)
          .map((d) => DoctorVerificationModel.fromJson(d))
          .toList(),
      totalCount: json['totalCount'] ?? 0,
      page: json['page'] ?? 1,
      pageSize: json['pageSize'] ?? 10,
      hasNextPage: json['hasNextPage'] ?? false,
    );
  }
}
