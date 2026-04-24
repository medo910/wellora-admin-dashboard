import 'package:admin_dashboard_graduation_project/core/errors/failures.dart';
import 'package:admin_dashboard_graduation_project/features/support_tickets/domain/entities/ticket_message_entity.dart';
import 'package:admin_dashboard_graduation_project/features/support_tickets/domain/repositories/support_repository.dart';
import 'package:dartz/dartz.dart';

class GetTicketMessagesUseCase {
  final SupportRepository repository;
  GetTicketMessagesUseCase(this.repository);

  Future<Either<Failure, List<TicketMessageEntity>>> call(String ticketId) {
    return repository.getTicketMessages(ticketId);
  }
}
