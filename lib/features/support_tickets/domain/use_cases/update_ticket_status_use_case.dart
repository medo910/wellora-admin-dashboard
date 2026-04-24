import 'package:admin_dashboard_graduation_project/core/errors/failures.dart';
import 'package:admin_dashboard_graduation_project/features/support_tickets/domain/repositories/support_repository.dart';
import 'package:dartz/dartz.dart';

class UpdateTicketStatusUseCase {
  final SupportRepository repository;
  UpdateTicketStatusUseCase(this.repository);

  Future<Either<Failure, String>> call(String ticketId, String status) {
    return repository.updateTicketStatus(ticketId, status);
  }
}
