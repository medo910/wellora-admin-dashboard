// lib/features/dashboard/domain/entities/dashboard_overview_entity.dart

import 'package:admin_dashboard_graduation_project/features/dashboard/domain/entities/doctor_stats_entity.dart';
import 'package:admin_dashboard_graduation_project/features/dashboard/domain/entities/recent_activity_entity.dart';
import 'package:admin_dashboard_graduation_project/features/dashboard/domain/entities/recent_ticket_entity.dart';
import 'package:admin_dashboard_graduation_project/features/dashboard/domain/entities/ticket_stats_entity.dart';
import 'package:admin_dashboard_graduation_project/features/dashboard/domain/entities/user_stats_entity.dart';
import 'package:admin_dashboard_graduation_project/features/dashboard/domain/entities/verification_stats_entity.dart';

// lib/features/dashboard/domain/entities/dashboard_overview_entity.dart
class DashboardOverviewEntity {
  final UserStatsEntity userStats;
  final DoctorStatsEntity doctorStats;
  final TicketStatsEntity ticketStats;
  final VerificationStatsEntity verificationStats;
  final List<ActionEntity> recentActions;
  final List<RecentTicketEntity> recentTickets;

  DashboardOverviewEntity({
    required this.userStats,
    required this.doctorStats,
    required this.ticketStats,
    required this.verificationStats,
    required this.recentActions,
    required this.recentTickets,
  });
}
