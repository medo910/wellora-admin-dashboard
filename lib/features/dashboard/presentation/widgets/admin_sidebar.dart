// lib/features/dashboard/presentation/widgets/admin_sidebar.dart
import 'package:admin_dashboard_graduation_project/features/dashboard/domain/models/nav_item_model.dart';
import 'package:admin_dashboard_graduation_project/features/dashboard/presentation/cubit/sidebar_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AdminSidebar extends StatelessWidget {
  const AdminSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SidebarCubit, SidebarState>(
      builder: (context, state) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: state.isCollapsed ? 80 : 260, // الـ Width حسب الحالة
          color: const Color(0xFF0F172A), // لون الـ Sidebar من v0.dev
          child: Column(
            children: [
              _buildLogo(state.isCollapsed),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: adminNavItems.length,
                  // itemBuilder: (context, index) => _SidebarTile(
                  //   item: adminNavItems[index],
                  //   isActive: state.selectedIndex == index,
                  //   isCollapsed: state.isCollapsed,
                  //   onTap: () {
                  //     context.read<SidebarCubit>().selectItem(index);
                  //     context.go(
                  //       adminNavItems[index].route,
                  //     ); // استخدام GoRouter للتنقل
                  //   },
                  // ),
                  itemBuilder: (context, index) {
                    final item = adminNavItems[index];

                    // 💡 بنعرف الصفحة الحالية من الـ GoRouter
                    final String currentLocation = GoRouterState.of(
                      context,
                    ).matchedLocation;
                    final bool isPathActive = currentLocation == item.route;

                    return _SidebarTile(
                      item: item,
                      isActive:
                          isPathActive, // بنبعت الحالة بناءً على المسار الحقيقي
                      isCollapsed: state.isCollapsed,
                      onTap: () {
                        context.read<SidebarCubit>().selectItem(index);
                        context.go(item.route);
                      },
                    );
                  },
                ),
              ),
              _buildCollapseToggle(context, state.isCollapsed),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLogo(bool isCollapsed) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white10)),
      ),
      child: Row(
        mainAxisAlignment: isCollapsed
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        children: [
          const Icon(
            Icons.favorite,
            color: Color(0xFF008080),
            size: 30,
          ), // شعار Wellora
          if (!isCollapsed) ...[
            const SizedBox(width: 12),
            const Text(
              "Wellora",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCollapseToggle(BuildContext context, bool isCollapsed) {
    return InkWell(
      onTap: () => context.read<SidebarCubit>().toggleSidebar(),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Colors.white10)),
        ),
        child: Row(
          mainAxisAlignment: isCollapsed
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          children: [
            Icon(
              isCollapsed ? Icons.chevron_right : Icons.chevron_left,
              color: Colors.white70,
            ),
            if (!isCollapsed) ...[
              const SizedBox(width: 10),
              const Text("Collapse", style: TextStyle(color: Colors.white70)),
            ],
          ],
        ),
      ),
    );
  }
}

// ويدجيت العنصر الواحد (Tile) - Extract Widget لتقليل حجم الملف
class _SidebarTile extends StatelessWidget {
  final NavItemModel item;
  final bool isActive;
  final bool isCollapsed;
  final VoidCallback onTap;

  const _SidebarTile({
    required this.item,
    required this.isActive,
    required this.isCollapsed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: isCollapsed ? item.title : "",
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: isActive
                  ? const Color(0xFF008080)
                  : Colors.transparent, // اللون لما يكون Active
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: isCollapsed
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              children: [
                Icon(
                  item.icon,
                  color: isActive ? Colors.white : Colors.white60,
                  size: 22,
                ),
                if (!isCollapsed) ...[
                  const SizedBox(width: 12),
                  Text(
                    item.title,
                    style: TextStyle(
                      color: isActive ? Colors.white : Colors.white60,
                      fontWeight: isActive
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
