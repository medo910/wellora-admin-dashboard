import 'package:admin_dashboard_graduation_project/core/errors/failures.dart';
import 'package:admin_dashboard_graduation_project/features/review_moderation/domain/entities/review_entity.dart';
import 'package:admin_dashboard_graduation_project/features/review_moderation/domain/repositories/review_repository.dart';
import 'package:dartz/dartz.dart';

class GetReviewsUseCase {
  final ReviewRepository repository;
  GetReviewsUseCase(this.repository);

  Future<Either<Failure, ReviewsPaginatedEntity>> call({
    int page = 1,
    int? doctorId,
    int? userId,
    double? minRating,
    double? maxRating,
    String? fromDate,
    String? toDate,
  }) {
    return repository.getReviews(
      page: page,
      doctorId: doctorId,
      userId: userId,
      minRating: minRating,
      maxRating: maxRating,
      fromDate: fromDate,
      toDate: toDate,
    );
  }
}
