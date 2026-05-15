class UserStatusDetailsEntity {
  final String? blockedByAdminName;
  final String? blockReason;
  final String? blockedAt;
  final String? suspendedByAdminName;
  final String? suspensionReason;
  final String? suspensionEndDate;

  UserStatusDetailsEntity({
    this.blockedByAdminName,
    this.blockReason,
    this.blockedAt,
    this.suspendedByAdminName,
    this.suspensionReason,
    this.suspensionEndDate,
  });
}
