import 'package:admin_dashboard_graduation_project/core/errors/failures.dart';
import 'package:admin_dashboard_graduation_project/features/support_tickets/domain/entities/support_stats_entity.dart';
import 'package:admin_dashboard_graduation_project/features/support_tickets/domain/entities/support_tickets_paginated_entity.dart';
import 'package:admin_dashboard_graduation_project/features/support_tickets/domain/entities/ticket_message_entity.dart';
import 'package:dartz/dartz.dart';

abstract class SupportRepository {
  Future<Either<Failure, SupportTicketsPaginatedEntity>> getTickets({
    int? page,
    int? pageSize,
    String? status,
    String? priority,
    String? category,
    int? userId,
    String? searchTerm,
    String? fromDate,
    String? toDate,
    String? sortBy,
    bool descending = true,
  });
  Future<Either<Failure, List<TicketMessageEntity>>> getTicketMessages(
    String ticketId,
  );
  Future<Either<Failure, TicketMessageEntity>> respondToTicket(
    String ticketId,
    String message,
  );
  Future<Either<Failure, String>> updateTicketStatus(
    String ticketId,
    String status,
  );
  Future<Either<Failure, String>> updateTicketPriority(
    String ticketId,
    String priority,
  );
  Future<Either<Failure, SupportStatsEntity>> getTicketsStatistics();
}
