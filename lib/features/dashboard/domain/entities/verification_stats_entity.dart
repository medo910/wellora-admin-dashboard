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
