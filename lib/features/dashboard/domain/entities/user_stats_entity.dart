import 'package:equatable/equatable.dart';

class UserStatsEntity extends Equatable {
  final int totalUsers;
  final int totalDoctors;
  final int totalPatients;
  final int activeUsers;
  final int newUsersThisMonth;
  final double percentageChange;
  final List<int> lastSevenDaysTrend;

  const UserStatsEntity({
    required this.totalUsers,
    required this.totalDoctors,
    required this.totalPatients,
    required this.activeUsers,
    required this.newUsersThisMonth,
    required this.percentageChange,
    required this.lastSevenDaysTrend,
  });

  @override
  List<Object?> get props => [
    totalUsers,
    activeUsers,
    percentageChange,
    lastSevenDaysTrend,
  ];
}
