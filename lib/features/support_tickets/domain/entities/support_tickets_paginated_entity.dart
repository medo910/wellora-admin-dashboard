import 'package:admin_dashboard_graduation_project/features/support_tickets/domain/entities/support_ticket_entity.dart';

class SupportTicketsPaginatedEntity {
  final List<SupportTicketEntity> tickets;
  final int totalCount;
  final bool hasNextPage;

  SupportTicketsPaginatedEntity({
    required this.tickets,
    required this.totalCount,
    required this.hasNextPage,
  });
}
