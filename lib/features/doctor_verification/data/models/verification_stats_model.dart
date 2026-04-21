// lib/features/doctor_verification/data/models/verification_stats_model.dart
import '../../domain/entities/verification_stats_entity.dart';

class VerificationStatsModel extends VerificationStatsEntity {
  VerificationStatsModel({
    required super.total,
    required super.pending,
    required super.approved,
    required super.rejected,
  });

  factory VerificationStatsModel.fromJson(Map<String, dynamic> json) {
    return VerificationStatsModel(
      total: json['totalVerifications'] ?? 0,
      pending: json['pendingVerifications'] ?? 0,
      approved: json['approvedVerifications'] ?? 0,
      rejected: json['rejectedVerifications'] ?? 0,
    );
  }
}
