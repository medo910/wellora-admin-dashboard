// lib/features/dashboard/domain/use_cases/get_dashboard_overview_use_case.dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../models/dashboard_overview_model.dart';
import '../repositories/dashboard_repository.dart';

class GetDashboardOverviewUseCase {
  final DashboardRepository repository;

  GetDashboardOverviewUseCase(this.repository);

  Future<Either<Failure, DashboardOverviewModel>> call() async {
    return await repository.getOverview(); // نداء مباشر للريبوزيتوري
  }
}
