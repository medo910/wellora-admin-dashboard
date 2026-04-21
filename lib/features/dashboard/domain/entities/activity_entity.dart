// lib/features/dashboard/domain/entities/activity_entity.dart
enum ActivityType {
  userRegistered,
  doctorVerified,
  ticketCreated,
  reviewFlagged,
  userBlocked,
  doctorApproved,
}

enum ActivityStatus { success, warning, urgent, pending }

class ActivityEntity {
  final String id;
  final String title;
  final String description;
  final String timestamp;
  final ActivityType type;
  final ActivityStatus status;
  final String? userName;
  final String? userAvatar;

  ActivityEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.type,
    required this.status,
    this.userName,
    this.userAvatar,
  });
}
