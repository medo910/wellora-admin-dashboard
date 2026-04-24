import 'package:admin_dashboard_graduation_project/core/errors/failures.dart';
import 'package:admin_dashboard_graduation_project/features/support_tickets/domain/entities/ticket_message_entity.dart';
import 'package:admin_dashboard_graduation_project/features/support_tickets/domain/repositories/support_repository.dart';
import 'package:dartz/dartz.dart';

class RespondToTicketUseCase {
  final SupportRepository repository;
  RespondToTicketUseCase(this.repository);

  Future<Either<Failure, TicketMessageEntity>> call(
    String ticketId,
    String message,
  ) {
    return repository.respondToTicket(ticketId, message);
  }
}
