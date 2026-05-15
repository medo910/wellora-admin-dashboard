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
      total: json['totalDoctors'] ?? 0,
      pending: json['pendingDoctors'] ?? 0,
      approved: json['approvedDoctors'] ?? 0,
      rejected: json['rejectedDoctors'] ?? 0,
    );
  }
}
