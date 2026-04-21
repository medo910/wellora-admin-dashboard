// lib/features/dashboard/data/repositories/dashboard_repository_impl.dart
import 'package:admin_dashboard_graduation_project/features/dashboard/domain/models/dashboard_overview_model.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../data_sources/dashboard_remote_data_source.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;

  DashboardRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, DashboardOverviewModel>> getOverview() async {
    try {
      final response = await remoteDataSource.getOverview();

      // هنا بنحول الـ JSON للموديل اللي أنت كتبته
      // تأكد إن الـ JSON اللي راجع متوافق مع الـ fromJson بتاعك
      final model = DashboardOverviewModel.fromJson(response);

      return Right(model);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
