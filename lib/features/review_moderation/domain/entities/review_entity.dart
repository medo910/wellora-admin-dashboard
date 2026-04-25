// features/review_moderation/domain/entities/review_entity.dart
import 'package:equatable/equatable.dart';

class ReviewEntity extends Equatable {
  final int reviewId;
  final int userId;
  final String userName;
  final String userEmail;
  final int targetId;
  final String targetType;
  final String doctorName;
  final double rating;
  final String comment;
  final DateTime reviewDate;
  final bool isDeleted;
  final DateTime? deletedAt;
  final String? deletedByAdminName;
  final String? deletionReason;

  const ReviewEntity({
    required this.reviewId,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.targetId,
    required this.targetType,
    required this.doctorName,
    required this.rating,
    required this.comment,
    required this.reviewDate,
    required this.isDeleted,
    this.deletedAt,
    this.deletedByAdminName,
    this.deletionReason,
  });

  @override
  List<Object?> get props => [reviewId, isDeleted];
}

// كيان منفصل للـ Pagination
class ReviewsPaginatedEntity {
  final List<ReviewEntity> reviews;
  final int totalCount;
  final int page;
  final int pageSize;
  final bool hasNextPage;

  ReviewsPaginatedEntity({
    required this.reviews,
    required this.totalCount,
    required this.page,
    required this.pageSize,
    required this.hasNextPage,
  });
}
