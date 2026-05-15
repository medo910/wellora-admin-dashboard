import 'package:admin_dashboard_graduation_project/features/dashboard/domain/entities/doctor_stats_entity.dart';
import 'package:admin_dashboard_graduation_project/features/dashboard/domain/entities/recent_activity_entity.dart';
import 'package:admin_dashboard_graduation_project/features/dashboard/domain/entities/recent_ticket_entity.dart';
import 'package:admin_dashboard_graduation_project/features/dashboard/domain/entities/ticket_stats_entity.dart';
import 'package:admin_dashboard_graduation_project/features/dashboard/domain/entities/user_registration_trend_entity.dart';
import 'package:admin_dashboard_graduation_project/features/dashboard/domain/entities/user_stats_entity.dart';
import 'package:admin_dashboard_graduation_project/features/dashboard/domain/entities/verification_stats_entity.dart';
import 'package:equatable/equatable.dart';

class DashboardOverviewEntity extends Equatable {
  final UserStatsEntity userStats;
  final DoctorStatsEntity doctorStats;
  final TicketStatsEntity ticketStats;
  final VerificationStatsEntity verificationStats;
  final List<UserRegistrationTrendEntity> userRegistrationTrend;
  final List<ActionEntity> recentActions;
  final List<RecentTicketEntity> recentTickets;

  const DashboardOverviewEntity({
    required this.userStats,
    required this.doctorStats,
    required this.ticketStats,
    required this.verificationStats,
    required this.userRegistrationTrend,
    required this.recentActions,
    required this.recentTickets,
  });

  @override
  List<Object?> get props => [
    userStats,
    doctorStats,
    ticketStats,
    verificationStats,
    userRegistrationTrend,
    recentActions,
    recentTickets,
  ];
}
