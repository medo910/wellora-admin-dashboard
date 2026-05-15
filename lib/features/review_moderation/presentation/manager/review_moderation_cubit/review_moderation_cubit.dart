import 'package:admin_dashboard_graduation_project/core/errors/failures.dart';
import 'package:admin_dashboard_graduation_project/features/review_moderation/domain/entities/review_entity.dart';
import 'package:admin_dashboard_graduation_project/features/review_moderation/domain/usecases/delete_review_use_case.dart';
import 'package:admin_dashboard_graduation_project/features/review_moderation/domain/usecases/get_deleted_reviews_use_case.dart';
import 'package:admin_dashboard_graduation_project/features/review_moderation/domain/usecases/get_reviews_use_case.dart';
import 'package:admin_dashboard_graduation_project/features/review_moderation/domain/usecases/restore_review_use_case.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'review_moderation_state.dart';

class ReviewModerationCubit extends Cubit<ReviewModerationState> {
  final GetReviewsUseCase getReviewsUseCase;
  final GetDeletedReviewsUseCase getDeletedUseCase;
  final DeleteReviewUseCase deleteReviewUseCase;
  final RestoreReviewUseCase restoreUseCase;
  ReviewModerationCubit({
    required this.getReviewsUseCase,
    required this.getDeletedUseCase,
    required this.deleteReviewUseCase,
    required this.restoreUseCase,
  }) : super(ReviewModerationInitial());

  int _currentPage = 1;
  int? _doctorId, _userId;
  double? _minR, _maxR;
  String? _fromDate, _toDate;
  bool _isDeletedTab = false;

  Future<void> fetchReviews({
    bool? isDeletedTab,
    int? page,
    int? doctorId,
    int? userId,
    double? minRating,
    double? maxRating,
    String? fromDate,
    String? toDate,
    bool isRefresh = true,
  }) async {
    if (isRefresh) emit(ReviewLoading());

    if (isDeletedTab != null) _isDeletedTab = isDeletedTab;
    if (page != null) _currentPage = page;
    if (doctorId != null) _doctorId = doctorId;
    if (userId != null) _userId = userId;
    if (minRating != null) _minR = minRating;
    if (maxRating != null) _maxR = maxRating;
    if (fromDate != null) _fromDate = fromDate;
    if (toDate != null) _toDate = toDate;

    final Either<Failure, ReviewsPaginatedEntity> result;

    if (_isDeletedTab) {
      result = await getDeletedUseCase(page: _currentPage);
    } else {
      result = await getReviewsUseCase(
        page: _currentPage,
        doctorId: _doctorId,
        userId: _userId,
        minRating: _minR,
        maxRating: _maxR,
        fromDate: _fromDate,
        toDate: _toDate,
      );
    }

    result.fold(
      (failure) => emit(ReviewFailure(failure.errmessage)),
      (paginatedData) => emit(
        ReviewSuccess(
          reviews: paginatedData.reviews,
          totalCount: paginatedData.totalCount,
          currentPage: _currentPage,
          hasNextPage: paginatedData.hasNextPage,
          isShowingDeleted: _isDeletedTab,
          currentDoctorId: _doctorId,
          currentUserId: _userId,
          minRating: _minR,
          maxRating: _maxR,
          currentDateRange: (_fromDate != null && _toDate != null)
              ? DateTimeRange(
                  start: DateTime.parse(_fromDate!),
                  end: DateTime.parse(_toDate!),
                )
              : null,
        ),
      ),
    );
  }

  Future<void> deleteReview(int reviewId, String reason) async {
    final currentState = state;
    if (currentState is ReviewSuccess) {
      emit(currentState.copyWith(isActionLoading: true));

      final result = await deleteReviewUseCase(reviewId, reason);

      result.fold((failure) => emit(ReviewFailure(failure.errmessage)), (
        successMsg,
      ) {
        final updatedList = currentState.reviews
            .where((r) => r.reviewId != reviewId)
            .toList();

        emit(
          currentState.copyWith(
            reviews: updatedList,
            totalCount: currentState.totalCount - 1,
            isActionLoading: false,
            actionMessage: successMsg,
          ),
        );
      });
    }
  }

  Future<void> restoreReview(int reviewId) async {
    final currentState = state;
    if (currentState is ReviewSuccess) {
      emit(currentState.copyWith(isActionLoading: true));

      final result = await restoreUseCase(reviewId);

      result.fold((failure) => emit(ReviewFailure(failure.errmessage)), (
        successMsg,
      ) {
        final updatedList = currentState.reviews
            .where((r) => r.reviewId != reviewId)
            .toList();

        emit(
          currentState.copyWith(
            reviews: updatedList,
            totalCount: currentState.totalCount - 1,
            isActionLoading: false,
            actionMessage: successMsg,
          ),
        );
      });
    }
  }

  void resetFilters() {
    _doctorId = _userId = _minR = _maxR = _fromDate = _toDate = null;
    _currentPage = 1;
    fetchReviews(isRefresh: true);
  }
}
