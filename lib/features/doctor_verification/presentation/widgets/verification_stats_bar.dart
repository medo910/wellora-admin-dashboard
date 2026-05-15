import 'package:admin_dashboard_graduation_project/features/doctor_verification/domain/entities/verification_stats_entity.dart';
import 'package:flutter/material.dart';

class VerificationStatsBar extends StatelessWidget {
  final VerificationStatsEntity stats;
  const VerificationStatsBar({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatCard(
          title: "Total",
          count: stats.total,
          icon: Icons.assignment_outlined,
          color: Colors.blue,
        ),
        const SizedBox(width: 16),
        _StatCard(
          title: "Pending",
          count: stats.pending,
          icon: Icons.history,
          color: Colors.orange,
        ),
        const SizedBox(width: 16),
        _StatCard(
          title: "Approved",
          count: stats.approved,
          icon: Icons.check_circle_outline,
          color: Colors.teal,
        ),
        const SizedBox(width: 16),
        _StatCard(
          title: "Rejected",
          count: stats.rejected,
          icon: Icons.highlight_off,
          color: Colors.red,
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                ),
                Text(
                  count.toString(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
