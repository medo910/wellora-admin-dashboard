import 'package:equatable/equatable.dart';

class TicketStatsEntity extends Equatable {
  final int totalTickets;
  final int openTickets;
  final int resolvedTickets;
  final int closedTickets;
  final double percentageChange;
  final List<int> lastSevenDaysTrend;
  final Map<String, int> ticketsByCategory;

  const TicketStatsEntity({
    required this.totalTickets,
    required this.openTickets,
    required this.resolvedTickets,
    required this.closedTickets,
    required this.percentageChange,
    required this.lastSevenDaysTrend,
    required this.ticketsByCategory,
  });

  @override
  List<Object?> get props => [
    totalTickets,
    resolvedTickets,
    percentageChange,
    lastSevenDaysTrend,
  ];
}
