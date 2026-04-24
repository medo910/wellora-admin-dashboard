// lib/features/support_tickets/domain/entities/support_stats_entity.dart
class SupportStatsEntity {
  final int totalTickets;
  final int openTickets;
  final int inProgressTickets;
  final int resolvedTickets;
  final int closedTickets;
  final int urgentTickets;
  final Map<String, int> ticketsByCategory;
  final Map<String, int> ticketsByStatus;

  SupportStatsEntity({
    required this.totalTickets,
    required this.openTickets,
    required this.inProgressTickets,
    required this.resolvedTickets,
    required this.closedTickets,
    required this.urgentTickets,
    required this.ticketsByCategory,
    required this.ticketsByStatus,
  });
}
