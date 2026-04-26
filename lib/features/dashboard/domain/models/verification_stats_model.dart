// lib/features/dashboard/data/models/verification_stats_model.dart
import 'package:admin_dashboard_graduation_project/features/dashboard/domain/entities/verification_stats_entity.dart';

class VerificationStatsModel extends VerificationStatsEntity {
  VerificationStatsModel({
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
    required super.doctorsByStatus, // 🚀 الجديد
  });

  // factory VerificationStatsModel.fromJson(Map<String, dynamic> json) {
  //   return VerificationStatsModel(
  //     totalVerifications: json['totalVerifications'] ?? 0,
  //     pendingVerifications: json['pendingVerifications'] ?? 0,
  //     approvedVerifications: json['approvedVerifications'] ?? 0,
  //     rejectedVerifications: json['rejectedVerifications'] ?? 0,
  //     verificationsByStatus: Map<String, int>.from(
  //       json['verificationsByStatus'] ?? {},
  //     ),
  //     approvedThisMonth: json['approvedThisMonth'] ?? 0,
  //     rejectedThisMonth: json['rejectedThisMonth'] ?? 0,
  //     lastSevenDaysTrend: List<int>.from(json['lastSevenDaysTrend'] ?? []),
  //   );
  // }
  factory VerificationStatsModel.fromJson(Map<String, dynamic> json) {
    return VerificationStatsModel(
      // 🚀 المفاتيح لازم تطابق الـ JSON بالظبط
      // totalVerifications: json['totalDoctors'] ?? 0,
      // pendingVerifications: json['pendingDoctors'] ?? 0,
      pendingDoctors: json['pendingDoctors'] ?? 0,

      // approvedVerifications: json['approvedDoctors'] ?? 0,
      // rejectedVerifications: json['rejectedDoctors'] ?? 0,
      // verificationsByStatus: Map<String, int>.from(
      //   json['doctorsByStatus'] ??
      //       {}, // 🚀 اسمها في الـ JSON هو doctorsByStatus
      // ),
      doctorsByStatus: Map<String, int>.from(
        json['doctorsByStatus'] ??
            {}, // 🚀 اسمها في الـ JSON هو doctorsByStatus
      ),
      approvedThisMonth: json['approvedThisMonth'] ?? 0,
      // rejectedThisMonth: json['rejectedThisMonth'] ?? 0,
      lastSevenDaysTrend: List<int>.from(json['lastSevenDaysTrend'] ?? []),
      // 💡 متنساش تضيف الـ percentageChange عشان الكارت اللي فوق
      percentageChange: (json['pendingDoctorsPercentageChange'] ?? 0)
          .toDouble(),
    );
  }
}
