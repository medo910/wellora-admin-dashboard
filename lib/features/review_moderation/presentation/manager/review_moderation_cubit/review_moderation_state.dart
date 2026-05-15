part of 'review_moderation_cubit.dart';

sealed class ReviewModerationState extends Equatable {
  const ReviewModerationState();

  @override
  List<Object?> get props => [];
}

final class ReviewModerationInitial extends ReviewModerationState {}

final class ReviewLoading extends ReviewModerationState {}

final class ReviewSuccess extends ReviewModerationState {
  final List<ReviewEntity> reviews;
  final int totalCount;
  final int currentPage;
  final bool hasNextPage;
  final bool isShowingDeleted;

  final int? currentDoctorId;
  final int? currentUserId;
  final double? minRating;
  final double? maxRating;
  final DateTimeRange? currentDateRange;
  final bool isActionLoading;
  final String? actionMessage;

  const ReviewSuccess({
    required this.reviews,
    required this.totalCount,
    required this.currentPage,
    required this.hasNextPage,
    required this.isShowingDeleted,
    this.currentDoctorId,
    this.currentUserId,
    this.minRating,
    this.maxRating,
    this.currentDateRange,
    this.isActionLoading = false,
    this.actionMessage,
  });

  ReviewSuccess copyWith({
    List<ReviewEntity>? reviews,
    int? totalCount,
    int? currentPage,
    bool? hasNextPage,
    bool? isShowingDeleted,
    int? currentDoctorId,
    int? currentUserId,
    double? minRating,
    double? maxRating,
    DateTimeRange? currentDateRange,
    bool? isActionLoading,
    String? actionMessage,
  }) {
    return ReviewSuccess(
      reviews: reviews ?? this.reviews,
      totalCount: totalCount ?? this.totalCount,
      currentPage: currentPage ?? this.currentPage,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      isShowingDeleted: isShowingDeleted ?? this.isShowingDeleted,
      currentDoctorId: currentDoctorId ?? this.currentDoctorId,
      currentUserId: currentUserId ?? this.currentUserId,
      minRating: minRating ?? this.minRating,
      maxRating: maxRating ?? this.maxRating,
      currentDateRange: currentDateRange ?? this.currentDateRange,
      isActionLoading: isActionLoading ?? this.isActionLoading,
      actionMessage: actionMessage,
    );
  }

  @override
  List<Object?> get props => [
    reviews,
    totalCount,
    currentPage,
    hasNextPage,
    isShowingDeleted,
    currentDoctorId,
    currentUserId,
    minRating,
    maxRating,
    currentDateRange,
    isActionLoading,
    actionMessage,
  ];
}

final class ReviewFailure extends ReviewModerationState {
  final String errorMessage;
  const ReviewFailure(this.errorMessage);
  @override
  List<Object?> get props => [errorMessage];
}

final class ReviewActionLoading extends ReviewModerationState {}

final class ReviewActionSuccess extends ReviewModerationState {
  final String message;
  const ReviewActionSuccess(this.message);
}

final class ReviewActionFailure extends ReviewModerationState {
  final String errorMessage;
  const ReviewActionFailure(this.errorMessage);
}
