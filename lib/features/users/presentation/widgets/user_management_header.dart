// lib/features/users/presentation/widgets/user_management_header.dart
import 'package:flutter/material.dart';

class UserManagementHeader extends StatelessWidget {
  final VoidCallback onExport;
  const UserManagementHeader({super.key, required this.onExport});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "User Management",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              "Manage all platform users, view details, and moderate accounts.",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: onExport,
          icon: const Icon(Icons.file_download_outlined, size: 18),
          label: const Text("Export Users"),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0D9488),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}
