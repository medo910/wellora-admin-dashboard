// lib/features/users/presentation/widgets/user_details_dialog/widgets/details_header.dart

import 'package:admin_dashboard_graduation_project/features/users/presentation/widgets/role_badge.dart';
import 'package:admin_dashboard_graduation_project/features/users/presentation/widgets/status_badge.dart';
import 'package:flutter/material.dart';
import '../../../domain/entities/user_entity.dart';

class DetailsHeader extends StatelessWidget {
  final UserEntity user;
  const DetailsHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 35,
          backgroundColor: Colors.teal.withOpacity(0.1),
          child: Text(
            user.fullName.substring(0, 1).toUpperCase(),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.fullName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  RoleBadge(type: user.userType),
                  const SizedBox(width: 8),
                  StatusBadge(
                    isBlocked: user.isBlocked,
                    isSuspended: user.isSuspended,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
