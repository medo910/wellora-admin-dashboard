import 'package:admin_dashboard_graduation_project/features/support_tickets/domain/entities/support_tickets_paginated_entity.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/support_stats_entity.dart';
import '../../domain/entities/ticket_message_entity.dart';
import '../../domain/repositories/support_repository.dart';
import '../data_sources/support_remote_data_source.dart';

class SupportRepositoryImpl implements SupportRepository {
  final SupportRemoteDataSource remoteDataSource;
  SupportRepositoryImpl(this.remoteDataSource);

  @override
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
  }) async {
    try {
      final paginatedData = await remoteDataSource.getTickets(
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
      return Right(paginatedData);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TicketMessageEntity>>> getTicketMessages(
    String ticketId,
  ) async {
    try {
      final messages = await remoteDataSource.getTicketMessages(ticketId);
      return Right(messages);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TicketMessageEntity>> respondToTicket(
    String ticketId,
    String message,
  ) async {
    try {
      final response = await remoteDataSource.respondToTicket(
        ticketId,
        message,
      );
      return Right(response);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> updateTicketStatus(
    String ticketId,
    String status,
  ) async {
    try {
      await remoteDataSource.updateTicketStatus(ticketId, status);
      return const Right("Status updated successfully");
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> updateTicketPriority(
    String ticketId,
    String priority,
  ) async {
    try {
      await remoteDataSource.updateTicketPriority(ticketId, priority);
      return const Right("Priority updated successfully");
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SupportStatsEntity>> getTicketsStatistics() async {
    try {
      final stats = await remoteDataSource.getTicketsStatistics();
      return Right(stats);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
