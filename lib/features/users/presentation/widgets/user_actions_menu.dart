// lib/features/users/presentation/widgets/user_actions_menu.dart
import 'package:admin_dashboard_graduation_project/features/users/presentation/widgets/user_details_dialog/user_details_dialog.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/user_entity.dart';
import 'user_actions_dialogs.dart'; // هنكربته دلوقتي

class UserActionsMenu extends StatelessWidget {
  final UserEntity user;
  const UserActionsMenu({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_horiz, color: Colors.grey),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (value) {
        if (value == 'view') showUserDetailsDialog(context, user);
        if (value == 'suspend') showSuspendUserDialog(context, user);
        if (value == 'block') showBlockUserDialog(context, user);
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          enabled: false,
          height: 30,
          child: Text(
            "Actions",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
        const PopupMenuDivider(),
        _buildItem(
          'view',
          Icons.visibility_outlined,
          "View Details",
          Colors.black87,
        ),
        _buildItem(
          'suspend',
          Icons.block_outlined,
          user.isSuspended ? "Unsuspend" : "Suspend",
          Colors.orange,
        ),
        _buildItem(
          'block',
          Icons.person_off_outlined,
          user.isBlocked ? "Unblock" : "Block",
          Colors.red,
        ),
      ],
    );
  }

  PopupMenuItem<String> _buildItem(
    String value,
    IconData icon,
    String text,
    Color color,
  ) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 12),
          Text(text, style: TextStyle(fontSize: 14, color: color)),
        ],
      ),
    );
  }
}
