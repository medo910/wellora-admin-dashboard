// lib/features/dashboard/domain/repositories/dashboard_repository.dart
import 'package:admin_dashboard_graduation_project/features/dashboard/domain/models/dashboard_overview_model.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';

abstract class DashboardRepository {
  Future<Either<Failure, DashboardOverviewModel>> getOverview();
}
