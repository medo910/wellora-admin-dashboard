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

  // 1. المخزن الداخلي للفلاتر (المسؤول عن ثبات الداتا)
  int _currentPage = 1;
  int? _doctorId, _userId;
  double? _minR, _maxR;
  String? _fromDate, _toDate;
  bool _isDeletedTab = false;

  // 📥 الميثود الرئيسية لجلب الريفيوهات (بتدعم كل فلاتر Swagger)
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

    // تحديث المخزن الداخلي فقط إذا تم تمرير قيم جديدة
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

  // 🛠️ أكشن المسح (Delete Review)
  // Future<void> deleteReview(int reviewId, String reason) async {
  //   final currentState = state;
  //   emit(ReviewActionLoading());

  //   final result = await deleteReviewUseCase(reviewId, reason);

  //   result.fold((failure) => emit(ReviewActionFailure(failure.errmessage)), (
  //     successMsg,
  //   ) {
  //     if (currentState is ReviewSuccess) {
  //       // 🚀 In-memory update: شيل الريفيو من القائمة فوراً عشان الـ UI يكون سريع
  //       final updatedList = currentState.reviews
  //           .where((r) => r.reviewId != reviewId)
  //           .toList();
  //       emit(
  //         currentState.copyWith(
  //           reviews: updatedList,
  //           totalCount: currentState.totalCount - 1,
  //         ),
  //       );
  //     }
  //     emit(ReviewActionSuccess(successMsg));
  //   });
  // }

  Future<void> deleteReview(int reviewId, String reason) async {
    final currentState = state;
    if (currentState is ReviewSuccess) {
      // 1. بنقول للـ UI إن فيه أكشن شغال بس اللستة لسه موجودة
      emit(currentState.copyWith(isActionLoading: true));

      final result = await deleteReviewUseCase(reviewId, reason);

      result.fold(
        (failure) => emit(ReviewFailure(failure.errmessage)), // لو ايرور كبير
        (successMsg) {
          // 2. بنشيل الريفيو من اللستة في الذاكرة
          final updatedList = currentState.reviews
              .where((r) => r.reviewId != reviewId)
              .toList();

          // 3. بنبعت الـ Success State الجديدة باللستة المحدثة ومعاها الرسالة
          emit(
            currentState.copyWith(
              reviews: updatedList,
              totalCount: currentState.totalCount - 1,
              isActionLoading: false,
              actionMessage: successMsg, // الـ Listener هيشوف دي ويطلع SnackBar
            ),
          );
        },
      );
    }
  }

  // 🛠️ أكشن الاستعادة (Restore Review)
  // Future<void> restoreReview(int reviewId) async {
  //   final currentState = state;
  //   emit(ReviewActionLoading());

  //   final result = await restoreUseCase(reviewId);

  //   result.fold((failure) => emit(ReviewActionFailure(failure.errmessage)), (
  //     successMsg,
  //   ) {
  //     if (currentState is ReviewSuccess) {
  //       // 🚀 شيل الريفيو من لستة الـ Deleted
  //       final updatedList = currentState.reviews
  //           .where((r) => r.reviewId != reviewId)
  //           .toList();
  //       emit(
  //         currentState.copyWith(
  //           reviews: updatedList,
  //           totalCount: currentState.totalCount - 1,
  //         ),
  //       );
  //     }
  //     emit(ReviewActionSuccess(successMsg));
  //   });
  // }

  // 🛠️ أكشن الاستعادة (Restore Review) المطور
  Future<void> restoreReview(int reviewId) async {
    final currentState = state;
    if (currentState is ReviewSuccess) {
      // 1. تفعيل حالة التحميل داخل الـ Success State نفسها
      emit(currentState.copyWith(isActionLoading: true));

      final result = await restoreUseCase(reviewId);

      result.fold((failure) => emit(ReviewFailure(failure.errmessage)), (
        successMsg,
      ) {
        // 2. تحديث اللستة في الذاكرة
        final updatedList = currentState.reviews
            .where((r) => r.reviewId != reviewId)
            .toList();

        // 3. إرسال الحالة الجديدة بالرسالة واللستة المحدثة
        emit(
          currentState.copyWith(
            reviews: updatedList,
            totalCount: currentState.totalCount - 1,
            isActionLoading: false,
            actionMessage: successMsg, // الـ Listener هيشوف دي ويطلع SnackBar
          ),
        );
      });
    }
  }

  // 🧹 تصفير كل شيء
  void resetFilters() {
    _doctorId = _userId = _minR = _maxR = _fromDate = _toDate = null;
    _currentPage = 1;
    fetchReviews(isRefresh: true);
  }
}
