// lib/features/dashboard/domain/entities/recent_activity_entity.dart

class ActionEntity {
  final String adminName;
  final String actionType;
  final String targetEntity;
  final DateTime timestamp;

  ActionEntity({
    required this.adminName,
    required this.actionType,
    required this.targetEntity,
    required this.timestamp,
  });
}

class PendingVerificationEntity {
  final int id;
  final String doctorName;
  final String specialization;
  final String status;
  final DateTime submittedAt;

  PendingVerificationEntity({
    required this.id,
    required this.doctorName,
    required this.specialization,
    required this.status,
    required this.submittedAt,
  });
}
