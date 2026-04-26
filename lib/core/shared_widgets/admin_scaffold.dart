// lib/shared_widgets/admin_scaffold.dart
import 'package:admin_dashboard_graduation_project/core/di/injection_container.dart';
import 'package:admin_dashboard_graduation_project/core/di/secure_storage_helper.dart';
import 'package:admin_dashboard_graduation_project/core/services/signalr_service.dart';
import 'package:admin_dashboard_graduation_project/features/dashboard/presentation/widgets/admin_header.dart';
import 'package:admin_dashboard_graduation_project/features/dashboard/presentation/widgets/admin_sidebar.dart';
import 'package:flutter/material.dart';

// lib/shared_widgets/admin_scaffold.dart
class AdminScaffold extends StatefulWidget {
  final Widget child;
  const AdminScaffold({super.key, required this.child});

  @override
  State<AdminScaffold> createState() => _AdminScaffoldState();
}

class _AdminScaffoldState extends State<AdminScaffold> {
  @override
  void initState() {
    super.initState();
    _setupSignalR();
  }

  void _setupSignalR() async {
    try {
      final token = await SecureStorageHelper.getAccessToken();
      if (token != null) {
        await sl<SignalRService>().init(token);
        print("🚀 SignalR Initialized from Dashboard");
      } else {
        print("⚠️ No token found for SignalR");
      }
    } catch (e) {
      print("❌ SignalR Init Error: $e");
    }
  }

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
                    child: widget.child,
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
