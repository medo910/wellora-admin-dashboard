import 'package:admin_dashboard_graduation_project/features/review_moderation/domain/entities/review_entity.dart';
import 'package:flutter/material.dart';

class TargetInfo extends StatelessWidget {
  final String doctorName;
  final DateTime date;
  const TargetInfo({super.key, required this.doctorName, required this.date});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.medication_outlined, size: 16, color: Colors.teal),
        const SizedBox(width: 4),
        Text(
          "Dr. $doctorName",
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        const Spacer(),
        Text(
          date.toString().substring(0, 10),
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}

class DeletedAuditInfo extends StatelessWidget {
  final ReviewEntity review;
  const DeletedAuditInfo({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.admin_panel_settings_outlined,
                size: 14,
                color: Colors.red,
              ),
              const SizedBox(width: 4),
              Text(
                "Deleted by: ${review.deletedByAdminName ?? 'Unknown'}",
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            "Reason: ${review.deletionReason ?? 'No reason provided'}",
            style: TextStyle(
              fontSize: 12,
              color: Colors.red.shade900,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;
  final VoidCallback? onPressed;

  const ActionButton({
    super.key,
    required this.label,
    required this.color,
    required this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18, color: color),
      label: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
      style: TextButton.styleFrom(backgroundColor: color.withOpacity(0.1)),
    );
  }
}
