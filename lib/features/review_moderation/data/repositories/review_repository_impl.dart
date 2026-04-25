// features/review_moderation/data/repositories/review_repository_impl.dart

import 'package:admin_dashboard_graduation_project/core/errors/failures.dart';
import 'package:admin_dashboard_graduation_project/features/review_moderation/data/datasources/review_remote_data_source.dart';
import 'package:admin_dashboard_graduation_project/features/review_moderation/data/models/review_model.dart';
import 'package:admin_dashboard_graduation_project/features/review_moderation/domain/entities/review_entity.dart';
import 'package:admin_dashboard_graduation_project/features/review_moderation/domain/repositories/review_repository.dart';
import 'package:dartz/dartz.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final ReviewRemoteDataSource remoteDataSource;

  ReviewRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, ReviewsPaginatedEntity>> getReviews({
    int page = 1,
    int pageSize = 10,
    int? doctorId,
    int? userId,
    double? minRating,
    double? maxRating,
    String? fromDate,
    String? toDate,
  }) async {
    try {
      final params = {
        "page": page,
        "pageSize": pageSize,
        if (minRating != null) "minRating": minRating,
        if (maxRating != null) "maxRating": maxRating,
        if (fromDate != null) "fromDate": fromDate,
        if (toDate != null) "toDate": toDate,
        if (doctorId != null) "doctorId": doctorId,
        if (userId != null) "userId": userId,
      };
      final result = await remoteDataSource.getReviews(params);

      final List<ReviewModel> models = (result['reviews'] as List)
          .map((json) => ReviewModel.fromJson(json))
          .toList();

      return Right(
        ReviewsPaginatedEntity(
          reviews: models,
          totalCount: result['totalCount'],
          page: result['page'],
          pageSize: result['pageSize'],
          hasNextPage: result['hasNextPage'],
        ),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ReviewsPaginatedEntity>> getDeletedReviews({
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final result = await remoteDataSource.getDeletedReviews(page, pageSize);
      final List<ReviewModel> models = (result['reviews'] as List)
          .map((json) => ReviewModel.fromJson(json))
          .toList();

      return Right(
        ReviewsPaginatedEntity(
          reviews: models,
          totalCount: result['totalCount'],
          page: result['page'],
          pageSize: result['pageSize'],
          hasNextPage: result['hasNextPage'],
        ),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> deleteReview({
    required int reviewId,
    required String reason,
  }) async {
    try {
      final message = await remoteDataSource.deleteReview(reviewId, reason);
      return Right(message);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> restoreReview({required int reviewId}) async {
    try {
      final message = await remoteDataSource.restoreReview(reviewId);
      return Right(message);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
