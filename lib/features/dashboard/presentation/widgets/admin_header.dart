import 'package:admin_dashboard_graduation_project/core/di/injection_container.dart';
import 'package:admin_dashboard_graduation_project/core/di/session_manager.dart';
import 'package:admin_dashboard_graduation_project/core/routes/app_router.dart';
import 'package:admin_dashboard_graduation_project/features/auth/domain/repos/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'notification_section.dart';

class AdminHeader extends StatelessWidget {
  const AdminHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: sl<SessionManager>(),
      builder: (context, _) {
        final session = sl<SessionManager>();

        final String name = session.userName.isEmpty
            ? "Admin User"
            : session.userName;
        final String role = session.userRole.isEmpty
            ? "Super Admin"
            : session.userRole;
        final String initials = _getInitials(name);

        return Container(
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
          ),
          child: Row(
            children: [
              const Text(
                "System Overview",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Spacer(),

              const NotificationSection(),

              const SizedBox(width: 24),

              PopupMenuButton<String>(
                offset: const Offset(0, 55),
                onSelected: (value) {
                  if (value == 'logout') _handleLogout(context);
                },
                itemBuilder: (context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    enabled: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          role,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(),
                  const PopupMenuItem<String>(
                    value: 'logout',
                    child: Row(
                      children: [
                        Icon(Icons.logout, color: Colors.red, size: 20),
                        SizedBox(width: 12),
                        Text("Logout", style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
                child: _AdminProfileTile(
                  name: name,
                  role: role,
                  initials: initials,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getInitials(String name) {
    if (name.trim().isEmpty) return "AD";
    if (!name.contains(' ')) return name.substring(0, 1).toUpperCase();
    return name.split(' ').map((e) => e[0]).take(2).join().toUpperCase();
  }

  void _handleLogout(BuildContext context) async {
    final result = await sl<AuthRepository>().logout();
    if (context.mounted) {
      result.fold(
        (l) => ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l.errmessage))),
        (r) => context.go(AppRouter.kLogin),
      );
    }
  }
}

class _AdminProfileTile extends StatelessWidget {
  final String name, role, initials;
  const _AdminProfileTile({
    required this.name,
    required this.role,
    required this.initials,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            Text(
              role,
              style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
            ),
          ],
        ),
        const SizedBox(width: 12),
        CircleAvatar(
          radius: 18,
          backgroundColor: const Color(0xFF008080).withOpacity(0.1),
          child: Text(
            initials,
            style: const TextStyle(
              color: Color(0xFF008080),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Icon(
          Icons.keyboard_arrow_down,
          color: Color(0xFF64748B),
          size: 18,
        ),
      ],
    );
  }
}
