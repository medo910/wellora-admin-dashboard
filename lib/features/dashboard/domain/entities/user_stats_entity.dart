// lib/features/dashboard/domain/entities/user_stats_entity.dart
class UserStatsEntity {
  final int totalUsers;
  final int totalDoctors;
  final int totalPatients;
  final int blockedUsers;
  final int suspendedUsers;
  final int activeUsers;
  final int newUsersThisMonth;

  UserStatsEntity({
    required this.totalUsers,
    required this.totalDoctors,
    required this.totalPatients,
    required this.blockedUsers,
    required this.suspendedUsers,
    required this.activeUsers,
    required this.newUsersThisMonth,
  });
}
