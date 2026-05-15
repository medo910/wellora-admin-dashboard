import 'package:admin_dashboard_graduation_project/features/review_moderation/domain/entities/review_entity.dart';

class ReviewModel extends ReviewEntity {
  const ReviewModel({
    required super.reviewId,
    required super.userId,
    required super.userName,
    required super.userEmail,
    required super.targetId,
    required super.targetType,
    required super.doctorName,
    required super.rating,
    required super.comment,
    required super.reviewDate,
    required super.isDeleted,
    super.deletedAt,
    super.deletedByAdminName,
    super.deletionReason,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      reviewId: json['reviewID'],
      userId: json['userID'],
      userName: json['userName'],
      userEmail: json['userEmail'],
      targetId: json['targetID'],
      targetType: json['targetType'],
      doctorName: json['doctorName'],
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'] ?? "",
      reviewDate: DateTime.parse(json['reviewDate']),
      isDeleted: json['isDeleted'],
      deletedAt: json['deletedAt'] != null
          ? DateTime.parse(json['deletedAt'])
          : null,
      deletedByAdminName: json['deletedByAdminName'],
      deletionReason: json['deletionReason'],
    );
  }
}
