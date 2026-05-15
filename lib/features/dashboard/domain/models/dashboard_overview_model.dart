import 'package:admin_dashboard_graduation_project/features/dashboard/domain/entities/dashboard_overview_entity.dart';
import 'package:admin_dashboard_graduation_project/features/dashboard/domain/entities/user_registration_trend_entity.dart';
import 'package:admin_dashboard_graduation_project/features/dashboard/domain/models/doctor_stats_model.dart';
import 'package:admin_dashboard_graduation_project/features/dashboard/domain/models/recent_activity_model.dart';
import 'package:admin_dashboard_graduation_project/features/dashboard/domain/models/recent_ticket_model.dart';
import 'package:admin_dashboard_graduation_project/features/dashboard/domain/models/ticket_stats_model.dart';
import 'package:admin_dashboard_graduation_project/features/dashboard/domain/models/user_registration_trend_model.dart';
import 'package:admin_dashboard_graduation_project/features/dashboard/domain/models/user_stats_model.dart';
import 'package:admin_dashboard_graduation_project/features/dashboard/domain/models/verification_stats_model.dart';

class DashboardOverviewModel extends DashboardOverviewEntity {
  const DashboardOverviewModel({
    required super.userStats,
    required super.doctorStats,
    required super.ticketStats,
    required super.verificationStats,
    required super.recentActions,
    required super.recentTickets,
    required super.userRegistrationTrend,
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
      userRegistrationTrend: (json['userRegistrationTrends'] as List? ?? [])
          .map((i) => UserRegistrationTrendModel.fromJson(i))
          .toList()
          .cast<UserRegistrationTrendEntity>(),
    );
  }
}
