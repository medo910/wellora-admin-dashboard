import 'package:admin_dashboard_graduation_project/features/dashboard/domain/entities/ticket_stats_entity.dart';

class TicketStatsModel extends TicketStatsEntity {
  TicketStatsModel({
    required super.totalTickets,
    required super.openTickets,
    required super.closedTickets,
    required super.urgentTickets,
    required super.ticketsByCategory,
  });

  factory TicketStatsModel.fromJson(Map<String, dynamic> json) {
    return TicketStatsModel(
      totalTickets: json['totalTickets'] ?? 0,
      openTickets: json['openTickets'] ?? 0,
      closedTickets: json['closedTickets'] ?? 0,
      urgentTickets: json['urgentTickets'] ?? 0,
      ticketsByCategory: Map<String, int>.from(json['ticketsByCategory'] ?? {}),
    );
  }
}
