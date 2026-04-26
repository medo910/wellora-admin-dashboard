// // lib/features/dashboard/domain/entities/doctor_stats_entity.dart
// class DoctorStatsEntity {
//   final int totalDoctors;
//   final int verifiedDoctors;
//   final int pendingVerification;
//   final int rejectedDoctors;
//   final double averageRating;
//   final int totalReviews;
//   final double percentageChange;
//   final List<int> lastSevenDaysTrend;

//   DoctorStatsEntity({
//     required this.totalDoctors,
//     required this.verifiedDoctors,
//     required this.pendingVerification,
//     required this.rejectedDoctors,
//     required this.averageRating,
//     required this.totalReviews,
//     required this.percentageChange,
//     required this.lastSevenDaysTrend,
//   });
// }

import 'package:equatable/equatable.dart';

class DoctorStatsEntity extends Equatable {
  final int totalDoctors;
  final int verifiedDoctors;
  final int pendingVerification;
  final double averageRating;
  final double percentageChange;
  final List<int> lastSevenDaysTrend;

  const DoctorStatsEntity({
    required this.totalDoctors,
    required this.verifiedDoctors,
    required this.pendingVerification,
    required this.averageRating,
    required this.percentageChange,
    required this.lastSevenDaysTrend,
  });

  @override
  List<Object?> get props => [
    verifiedDoctors,
    percentageChange,
    lastSevenDaysTrend,
  ];
}
