import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final bool isBlocked;
  final bool isSuspended;

  const StatusBadge({
    super.key,
    required this.isBlocked,
    required this.isSuspended,
  });

  @override
  Widget build(BuildContext context) {
    Color color = Colors.green;
    String label = "Active";

    if (isBlocked) {
      color = Colors.red;
      label = "Blocked";
    } else if (isSuspended) {
      color = Colors.orange;
      label = "Suspended";
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
