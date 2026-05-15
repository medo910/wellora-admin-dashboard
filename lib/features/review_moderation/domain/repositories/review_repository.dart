import 'package:admin_dashboard_graduation_project/core/errors/failures.dart';
import 'package:admin_dashboard_graduation_project/features/review_moderation/domain/entities/review_entity.dart';
import 'package:dartz/dartz.dart';

abstract class ReviewRepository {
  Future<Either<Failure, ReviewsPaginatedEntity>> getReviews({
    int page = 1,
    int pageSize = 10,
    int? doctorId,
    int? userId,
    double? minRating,
    double? maxRating,
    String? fromDate,
    String? toDate,
  });

  Future<Either<Failure, ReviewsPaginatedEntity>> getDeletedReviews({
    int page = 1,
    int pageSize = 10,
  });

  Future<Either<Failure, String>> deleteReview({
    required int reviewId,
    required String reason,
  });

  Future<Either<Failure, String>> restoreReview({required int reviewId});
}
