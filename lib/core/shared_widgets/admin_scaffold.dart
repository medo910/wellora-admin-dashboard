// lib/shared_widgets/admin_scaffold.dart
import 'package:admin_dashboard_graduation_project/features/dashboard/presentation/widgets/admin_header.dart';
import 'package:admin_dashboard_graduation_project/features/dashboard/presentation/widgets/admin_sidebar.dart';
import 'package:flutter/material.dart';

// lib/shared_widgets/admin_scaffold.dart
class AdminScaffold extends StatelessWidget {
  final Widget child;
  const AdminScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const AdminSidebar(), // الـ Sidebar اللي لسه مخلصينه
          Expanded(
            child: Column(
              children: [
                const AdminHeader(), // الهيدر (هعملهولك الخطوة الجاية)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: child,
                  ),
                ), // المحتوى المتغير
              ],
            ),
          ),
        ],
      ),
    );
  }
}
