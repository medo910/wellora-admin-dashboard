import 'package:admin_dashboard_graduation_project/core/errors/failures.dart';
import 'package:admin_dashboard_graduation_project/features/review_moderation/domain/repositories/review_repository.dart';
import 'package:dartz/dartz.dart';

class RestoreReviewUseCase {
  final ReviewRepository repository;
  RestoreReviewUseCase(this.repository);

  Future<Either<Failure, String>> call(int id) =>
      repository.restoreReview(reviewId: id);
}
