import 'package:flutter/material.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/entities/user_status_details_entity.dart';

class PenaltySection extends StatelessWidget {
  final UserEntity user;
  final UserStatusDetailsEntity? details;
  final bool isLoading;

  const PenaltySection({
    super.key,
    required this.user,
    this.details,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final bool isBlocked = user.isBlocked;
    final Color color = isBlocked ? Colors.red : Colors.orange;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isBlocked ? Icons.gavel : Icons.timer,
                color: color,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                isBlocked ? "Blocking Details" : "Suspension Details",
                style: TextStyle(color: color, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (isLoading)
            const LinearProgressIndicator()
          else if (details != null) ...[
            _Row(
              label: "Reason",
              value: isBlocked
                  ? details!.blockReason
                  : details!.suspensionReason,
            ),
            _Row(
              label: "By Admin",
              value: isBlocked
                  ? details!.blockedByAdminName
                  : details!.suspendedByAdminName,
            ),
            _Row(
              label: isBlocked ? "Blocked At" : "End Date",
              value: isBlocked
                  ? details!.blockedAt?.substring(0, 10)
                  : details!.suspensionEndDate?.substring(0, 10),
            ),
          ],
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String? value;
  const _Row({required this.label, this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black87, fontSize: 13),
          children: [
            TextSpan(
              text: "$label: ",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: value ?? "N/A"),
          ],
        ),
      ),
    );
  }
}
