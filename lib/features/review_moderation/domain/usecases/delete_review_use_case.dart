import 'package:admin_dashboard_graduation_project/core/errors/failures.dart';
import 'package:admin_dashboard_graduation_project/features/review_moderation/domain/repositories/review_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteReviewUseCase {
  final ReviewRepository repository;
  DeleteReviewUseCase(this.repository);

  Future<Either<Failure, String>> call(int id, String reason) =>
      repository.deleteReview(reviewId: id, reason: reason);
}
