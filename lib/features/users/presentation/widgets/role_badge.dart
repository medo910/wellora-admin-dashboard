import 'package:flutter/material.dart';
import '../../domain/entities/user_entity.dart';

class RoleBadge extends StatelessWidget {
  final UserType type; // غيرنا الإسم لـ type
  const RoleBadge({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    Color color = type == UserType.doctor ? Colors.blue : Colors.teal;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        type.name.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
