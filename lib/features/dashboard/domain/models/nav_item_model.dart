// lib/features/dashboard/domain/models/nav_item_model.dart
import 'package:admin_dashboard_graduation_project/core/routes/app_router.dart';
import 'package:flutter/material.dart';

class NavItemModel {
  final String title;
  final IconData icon;
  final String route;

  NavItemModel({required this.title, required this.icon, required this.route});
}

final List<NavItemModel> adminNavItems = [
  NavItemModel(
    title: "Dashboard",
    icon: Icons.grid_view_rounded,
    route: AppRouter.kDashboard,
  ),
  NavItemModel(
    title: "User Management",
    icon: Icons.people_outline,
    route: AppRouter.kUsers,
  ),
  NavItemModel(
    title: "Doctor Verification",
    icon: Icons.verified_user_outlined,
    route: AppRouter.kDoctorVerification,
  ),
  NavItemModel(
    title: "Support Tickets",
    icon: Icons.confirmation_number_outlined,
    route: AppRouter.kSupportTickets,
  ),
  NavItemModel(
    title: "Review Moderation",
    icon: Icons.message_outlined,
    route: AppRouter.kReviewModeration,
  ),
  // NavItemModel(
  //   title: "Audit Logs",
  //   icon: Icons.history_edu_outlined,
  //   route: '/admin/audit',
  // ),
];
