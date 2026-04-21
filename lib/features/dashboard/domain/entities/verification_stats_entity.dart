// lib/features/dashboard/domain/entities/verification_stats_entity.dart
class VerificationStatsEntity {
  final int totalVerifications;
  final int pendingVerifications;
  final int approvedVerifications;
  final int rejectedVerifications;
  final Map<String, int> verificationsByStatus;
  final int approvedThisMonth;
  final int rejectedThisMonth;

  VerificationStatsEntity({
    required this.totalVerifications,
    required this.pendingVerifications,
    required this.approvedVerifications,
    required this.rejectedVerifications,
    required this.verificationsByStatus,
    required this.approvedThisMonth,
    required this.rejectedThisMonth,
  });
}
