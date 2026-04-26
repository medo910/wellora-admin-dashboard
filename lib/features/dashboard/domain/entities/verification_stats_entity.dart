// // lib/features/dashboard/domain/entities/verification_stats_entity.dart
// class VerificationStatsEntity {
//   final int totalVerifications;
//   final int pendingVerifications;
//   final int approvedVerifications;
//   final int rejectedVerifications;
//   final Map<String, int> verificationsByStatus;
//   final List<int> lastSevenDaysTrend;
//   final int approvedThisMonth;
//   final int rejectedThisMonth;

//   VerificationStatsEntity({
//     required this.totalVerifications,
//     required this.pendingVerifications,
//     required this.approvedVerifications,
//     required this.rejectedVerifications,
//     required this.verificationsByStatus,
//     required this.lastSevenDaysTrend,
//     required this.approvedThisMonth,
//     required this.rejectedThisMonth,
//   });
// }

import 'package:equatable/equatable.dart';

class VerificationStatsEntity extends Equatable {
  final int pendingDoctors;
  final int approvedThisMonth;
  final double percentageChange;
  final List<int> lastSevenDaysTrend;
  final Map<String, int> doctorsByStatus;

  const VerificationStatsEntity({
    required this.pendingDoctors,
    required this.approvedThisMonth,
    required this.percentageChange,
    required this.lastSevenDaysTrend,
    required this.doctorsByStatus,
  });

  @override
  List<Object?> get props => [
    pendingDoctors,
    percentageChange,
    lastSevenDaysTrend,
    doctorsByStatus,
  ];
}
