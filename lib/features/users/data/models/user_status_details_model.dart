// lib/features/users/data/models/user_status_details_model.dart
import '../../domain/entities/user_status_details_entity.dart';

class UserStatusDetailsModel extends UserStatusDetailsEntity {
  UserStatusDetailsModel({
    super.blockedByAdminName,
    super.blockReason,
    super.blockedAt,
    super.suspendedByAdminName,
    super.suspensionReason,
    super.suspensionEndDate,
  });

  factory UserStatusDetailsModel.fromJson(Map<String, dynamic> json) {
    return UserStatusDetailsModel(
      blockedByAdminName: json['blockedByAdminName'],
      blockReason: json['blockReason'],
      blockedAt: json['blockedAt'],
      suspendedByAdminName: json['suspendedByAdminName'],
      suspensionReason: json['suspensionReason'],
      suspensionEndDate: json['suspensionEndDate'],
    );
  }
}
