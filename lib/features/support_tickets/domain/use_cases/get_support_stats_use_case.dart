import 'package:admin_dashboard_graduation_project/core/errors/failures.dart';
import 'package:admin_dashboard_graduation_project/features/support_tickets/domain/entities/support_stats_entity.dart';
import 'package:admin_dashboard_graduation_project/features/support_tickets/domain/repositories/support_repository.dart';
import 'package:dartz/dartz.dart';

class GetSupportStatsUseCase {
  final SupportRepository repository;
  GetSupportStatsUseCase(this.repository);

  Future<Either<Failure, SupportStatsEntity>> call() {
    return repository.getTicketsStatistics();
  }
}
