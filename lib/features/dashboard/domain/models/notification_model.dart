import 'package:admin_dashboard_graduation_project/features/dashboard/domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.title,
    required super.message,
    required super.type,
    required super.isRead,
    required super.createdAt,
    super.relatedEntityType,
    super.relatedEntityId,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    String mappedType = 'Unknown';
    if (json['type'] == 1) mappedType = 'DoctorVerificationSubmitted';
    if (json['type'] == 2) mappedType = 'DoctorRegistrationSubmitted';
    return NotificationModel(
      id: json['id'],
      title: json['title'],
      message: json['message'],
      // type: json['type'],
      type: mappedType,
      isRead: json['isRead'],
      createdAt: DateTime.parse(json['createdAt']),
      relatedEntityType: json['relatedEntityType'],
      relatedEntityId: json['relatedEntityId'],
    );
  }
}
