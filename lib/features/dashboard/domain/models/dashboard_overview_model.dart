// // lib/features/dashboard/data/models/dashboard_overview_model.dart
// class DashboardOverviewModel {
//   final UserStatistics userStats;
//   final DoctorStatistics doctorStats;
//   final TicketStatistics ticketStats;

//   DashboardOverviewModel({
//     required this.userStats,
//     required this.doctorStats,
//     required this.ticketStats,
//   });

//   factory DashboardOverviewModel.fromJson(Map<String, dynamic> json) {
//     return DashboardOverviewModel(
//       userStats: UserStatistics.fromJson(json['userStatistics']),
//       doctorStats: DoctorStatistics.fromJson(json['doctorStatistics']),
//       ticketStats: TicketStatistics.fromJson(json['ticketStatistics']),
//     );
//   }
// }

// class UserStatistics {
//   final int totalUsers;
//   final int activeUsers;
//   final double growth; // مش موجودة صريحة بس هنحسبها أو نثبتها مبدئياً

//   UserStatistics({
//     required this.totalUsers,
//     required this.activeUsers,
//     required this.growth,
//   });

//   factory UserStatistics.fromJson(Map<String, dynamic> json) {
//     return UserStatistics(
//       totalUsers: json['totalUsers'] ?? 0,
//       activeUsers: json['activeUsers'] ?? 0,
//       growth: 12.5, // قيمة تجريبية بناءً على الديزاين
//     );
//   }
// }
// // ... كمل باقي الـ Stats بنفس النمط بناءً على الـ Swagger

// class DoctorStatistics {
//   final int totalDoctors;
//   final int activeDoctors;
//   final double growth;

//   DoctorStatistics({
//     required this.totalDoctors,
//     required this.activeDoctors,
//     required this.growth,
//   });

//   factory DoctorStatistics.fromJson(Map<String, dynamic> json) {
//     return DoctorStatistics(
//       totalDoctors: json['totalDoctors'] ?? 0,
//       activeDoctors: json['activeDoctors'] ?? 0,
//       growth: 8.3, // قيمة تجريبية
//     );
//   }
// }

// class TicketStatistics {
//   final int totalTickets;
//   final int openTickets;
//   final double growth;

//   TicketStatistics({
//     required this.totalTickets,
//     required this.openTickets,
//     required this.growth,
//   });

//   factory TicketStatistics.fromJson(Map<String, dynamic> json) {
//     return TicketStatistics(
//       totalTickets: json['totalTickets'] ?? 0,
//       openTickets: json['openTickets'] ?? 0,
//       growth: -5.2, // قيمة تجريبية
//     );
//   }
// }

// lib/features/dashboard/data/models/dashboard_overview_model.dart
import 'package:admin_dashboard_graduation_project/features/dashboard/domain/entities/dashboard_overview_entity.dart';
import 'package:admin_dashboard_graduation_project/features/dashboard/domain/models/doctor_stats_model.dart';
import 'package:admin_dashboard_graduation_project/features/dashboard/domain/models/recent_activity_model.dart';
import 'package:admin_dashboard_graduation_project/features/dashboard/domain/models/recent_ticket_model.dart';
import 'package:admin_dashboard_graduation_project/features/dashboard/domain/models/ticket_stats_model.dart';
import 'package:admin_dashboard_graduation_project/features/dashboard/domain/models/user_stats_model.dart';
import 'package:admin_dashboard_graduation_project/features/dashboard/domain/models/verification_stats_model.dart';

class DashboardOverviewModel extends DashboardOverviewEntity {
  DashboardOverviewModel({
    required super.userStats,
    required super.doctorStats,
    required super.ticketStats,
    required super.verificationStats,
    required super.recentActions,
    required super.recentTickets,
  });

  factory DashboardOverviewModel.fromJson(Map<String, dynamic> json) {
    return DashboardOverviewModel(
      userStats: UserStatsModel.fromJson(json['userStatistics']),
      doctorStats: DoctorStatsModel.fromJson(json['doctorStatistics']),
      ticketStats: TicketStatsModel.fromJson(json['ticketStatistics']),
      verificationStats: VerificationStatsModel.fromJson(
        json['verificationStatistics'],
      ),
      recentActions: (json['recentActivity']['recentActions'] as List)
          .map((i) => ActionModel.fromJson(i))
          .toList(),
      recentTickets: (json['recentActivity']['recentTickets'] as List)
          .map((i) => RecentTicketModel.fromJson(i))
          .toList(),
    );
  }
}
