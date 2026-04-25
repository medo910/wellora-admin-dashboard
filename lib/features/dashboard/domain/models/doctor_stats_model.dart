import 'package:admin_dashboard_graduation_project/features/dashboard/domain/entities/doctor_stats_entity.dart';

class DoctorStatsModel extends DoctorStatsEntity {
  DoctorStatsModel({
    required super.totalDoctors,
    required super.verifiedDoctors,
    required super.pendingVerification,
    required super.rejectedDoctors,
    required super.averageRating,
    required super.totalReviews,
    required super.percentageChange,
  });

  factory DoctorStatsModel.fromJson(Map<String, dynamic> json) {
    return DoctorStatsModel(
      totalDoctors: json['totalDoctors'] ?? 0,
      verifiedDoctors: json['verifiedDoctors'] ?? 0,
      pendingVerification: json['pendingVerification'] ?? 0,
      rejectedDoctors: json['rejectedDoctors'] ?? 0,
      averageRating: (json['averageRating'] ?? 0).toDouble(),
      totalReviews: json['totalReviews'] ?? 0,
      percentageChange: (json['verifiedDoctorsPercentageChange'] ?? 0)
          .toDouble(),
    );
  }
}
