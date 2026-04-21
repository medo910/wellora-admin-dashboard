class VerificationStatsEntity {
  final int total;
  final int pending;
  final int approved;
  final int rejected;

  VerificationStatsEntity({
    required this.total,
    required this.pending,
    required this.approved,
    required this.rejected,
  });
}
