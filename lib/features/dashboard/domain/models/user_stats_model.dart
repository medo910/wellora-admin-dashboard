// lib/features/dashboard/data/models/user_stats_model.dart
import 'package:admin_dashboard_graduation_project/features/dashboard/domain/entities/user_stats_entity.dart';

class UserStatsModel extends UserStatsEntity {
  UserStatsModel({
    required super.totalUsers,
    required super.totalDoctors,
    required super.totalPatients,
    required super.blockedUsers,
    required super.suspendedUsers,
    required super.activeUsers,
    required super.newUsersThisMonth,
    required super.percentageChange,
  });

  factory UserStatsModel.fromJson(Map<String, dynamic> json) {
    return UserStatsModel(
      totalUsers: json['totalUsers'] ?? 0,
      totalDoctors: json['totalDoctors'] ?? 0,
      totalPatients: json['totalPatients'] ?? 0,
      blockedUsers: json['blockedUsers'] ?? 0,
      suspendedUsers: json['suspendedUsers'] ?? 0,
      activeUsers: json['activeUsers'] ?? 0,
      newUsersThisMonth: json['newUsersThisMonth'] ?? 0,
      percentageChange: (json['newUsersPercentageChange'] ?? 0).toDouble(),
    );
  }
}
