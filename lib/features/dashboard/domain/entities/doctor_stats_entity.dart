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
