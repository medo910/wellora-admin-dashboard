// lib/features/support_tickets/data/models/support_stats_model.dart
import 'package:admin_dashboard_graduation_project/features/support_tickets/domain/entities/support_stats_entity.dart';

class SupportStatsModel extends SupportStatsEntity {
  SupportStatsModel({
    required super.totalTickets,
    required super.openTickets,
    required super.inProgressTickets,
    required super.resolvedTickets,
    required super.closedTickets,
    required super.urgentTickets,
    required super.ticketsByCategory,
    required super.ticketsByStatus,
  });

  factory SupportStatsModel.fromJson(Map<String, dynamic> json) {
    return SupportStatsModel(
      totalTickets: json['totalTickets'] ?? 0,
      openTickets: json['openTickets'] ?? 0,
      inProgressTickets: json['inProgressTickets'] ?? 0,
      resolvedTickets: json['resolvedTickets'] ?? 0,
      closedTickets: json['closedTickets'] ?? 0,
      urgentTickets: json['urgentTickets'] ?? 0,
      // تحويل الـ JSON Maps لـ Map<String, int> في دارت
      ticketsByCategory: Map<String, int>.from(json['ticketsByCategory'] ?? {}),
      ticketsByStatus: Map<String, int>.from(json['ticketsByStatus'] ?? {}),
    );
  }
}
