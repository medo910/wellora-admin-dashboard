import 'package:admin_dashboard_graduation_project/core/errors/failures.dart';
import 'package:admin_dashboard_graduation_project/features/support_tickets/domain/entities/support_tickets_paginated_entity.dart';
import 'package:admin_dashboard_graduation_project/features/support_tickets/domain/repositories/support_repository.dart';
import 'package:dartz/dartz.dart';

class GetTicketsUseCase {
  final SupportRepository repository;
  GetTicketsUseCase(this.repository);

  Future<Either<Failure, SupportTicketsPaginatedEntity>> call({
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
  }) {
    return repository.getTickets(
      page: page,
      pageSize: pageSize,
      status: status,
      priority: priority,
      category: category,
      userId: userId,
      searchTerm: searchTerm,
      fromDate: fromDate,
      toDate: toDate,
      sortBy: sortBy,
      descending: descending,
    );
  }
}
