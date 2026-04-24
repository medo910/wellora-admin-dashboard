import 'package:admin_dashboard_graduation_project/core/errors/failures.dart';
import 'package:admin_dashboard_graduation_project/features/support_tickets/domain/repositories/support_repository.dart';
import 'package:dartz/dartz.dart';

class UpdateTicketPriorityUseCase {
  final SupportRepository repository;
  UpdateTicketPriorityUseCase(this.repository);

  Future<Either<Failure, String>> call(String ticketId, String priority) {
    return repository.updateTicketPriority(ticketId, priority);
  }
}
