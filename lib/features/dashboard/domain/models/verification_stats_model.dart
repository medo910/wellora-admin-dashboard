import 'package:admin_dashboard_graduation_project/features/dashboard/domain/entities/verification_stats_entity.dart';

class VerificationStatsModel extends VerificationStatsEntity {
  const VerificationStatsModel({
    // required super.totalVerifications,
    // required super.pendingVerifications,
    // required super.approvedVerifications,
    // required super.rejectedVerifications,
    // required super.verificationsByStatus,
    required super.approvedThisMonth,
    // required super.rejectedThisMonth,
    required super.lastSevenDaysTrend,
    required super.percentageChange,
    required super.pendingDoctors,
    required super.doctorsByStatus,
  });

  factory VerificationStatsModel.fromJson(Map<String, dynamic> json) {
    return VerificationStatsModel(
      pendingDoctors: json['pendingDoctors'] ?? 0,

      doctorsByStatus: Map<String, int>.from(json['doctorsByStatus'] ?? {}),
      approvedThisMonth: json['approvedThisMonth'] ?? 0,
      // rejectedThisMonth: json['rejectedThisMonth'] ?? 0,
      lastSevenDaysTrend: List<int>.from(json['lastSevenDaysTrend'] ?? []),
      percentageChange: (json['pendingDoctorsPercentageChange'] ?? 0)
          .toDouble(),
    );
  }
}
