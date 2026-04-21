// lib/features/users/presentation/widgets/user_table_widget.dart
import 'package:admin_dashboard_graduation_project/features/users/presentation/widgets/user_actions_menu.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/user_entity.dart';
import 'status_badge.dart';
import 'role_badge.dart'; // تأكد إنك كريت الـ RoleBadge اللي عملناها سوا

class UserTableWidget extends StatelessWidget {
  final List<UserEntity> users;
  final Function(UserEntity, bool?) onSelectUser;

  const UserTableWidget({
    super.key,
    required this.users,
    required this.onSelectUser,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Scrollbar(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width - 320,
              ), // لضمان العرض
              child: DataTable(
                columnSpacing: 20, // زودنا المسافة شوية للراحة
                // onSelectAll: onSelectAll,
                columns: const [
                  DataColumn(
                    label: Text(
                      "User",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "Role",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "Status",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "Joined",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "Actions",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
                rows: users.map((user) {
                  return DataRow(
                    cells: [
                      DataCell(_buildUserCell(user)),
                      DataCell(RoleBadge(type: user.userType)),
                      DataCell(
                        StatusBadge(
                          isBlocked: user.isBlocked,
                          isSuspended: user.isSuspended,
                        ),
                      ),
                      DataCell(Text(user.createdAt.substring(0, 10))),
                      DataCell(UserActionsMenu(user: user)),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserCell(UserEntity user) {
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: Colors.teal.withValues(alpha: 0.1),
          child: Text(
            user.fullName.isNotEmpty ? user.fullName.substring(0, 1) : "?",
            style: const TextStyle(fontSize: 12, color: Colors.teal),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              user.fullName,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
            ),
            Text(
              user.email,
              style: const TextStyle(color: Colors.grey, fontSize: 11),
            ),
          ],
        ),
      ],
    );
  }
}
