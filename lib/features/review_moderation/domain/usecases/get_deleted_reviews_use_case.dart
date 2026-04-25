import 'package:admin_dashboard_graduation_project/core/errors/failures.dart';
import 'package:admin_dashboard_graduation_project/features/review_moderation/domain/entities/review_entity.dart';
import 'package:admin_dashboard_graduation_project/features/review_moderation/domain/repositories/review_repository.dart';
import 'package:dartz/dartz.dart';

class GetDeletedReviewsUseCase {
  final ReviewRepository repository;
  GetDeletedReviewsUseCase(this.repository);

  Future<Either<Failure, ReviewsPaginatedEntity>> call({
    int page = 1,
    int pageSize = 10,
  }) => repository.getDeletedReviews(page: page, pageSize: pageSize);
}
