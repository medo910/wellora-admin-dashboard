class TicketStatsEntity {
  final int totalTickets;
  final int openTickets;
  final int closedTickets;
  final int urgentTickets;
  final Map<String, int> ticketsByCategory;

  TicketStatsEntity({
    required this.totalTickets,
    required this.openTickets,
    required this.closedTickets,
    required this.urgentTickets,
    required this.ticketsByCategory,
  });
}
