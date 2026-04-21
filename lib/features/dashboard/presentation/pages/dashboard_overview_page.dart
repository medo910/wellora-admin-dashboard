// lib/features/dashboard/presentation/pages/dashboard_overview_page.dart
import 'package:admin_dashboard_graduation_project/features/dashboard/domain/entities/dashboard_overview_entity.dart';
import 'package:admin_dashboard_graduation_project/features/dashboard/presentation/cubit/dashboard_cubit/dashboard_cubit.dart';
import 'package:admin_dashboard_graduation_project/features/dashboard/presentation/cubit/dashboard_cubit/dashboard_state.dart';
import 'package:admin_dashboard_graduation_project/features/dashboard/presentation/widgets/activity_feed.dart';
import 'package:admin_dashboard_graduation_project/features/dashboard/presentation/widgets/registration_trends_chart.dart';
import 'package:admin_dashboard_graduation_project/features/dashboard/presentation/widgets/stat_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardOverviewPage extends StatelessWidget {
  const DashboardOverviewPage({super.key});

  // @override
  // Widget build(BuildContext context) {
  //   return BlocProvider(
  //     create: (context) =>
  //         sl<DashboardCubit>()..getOverview(), // استخدام sl لجلب الـ Cubit
  //     child: BlocBuilder<DashboardCubit, DashboardState>(
  //       builder: (context, state) {
  //         if (state is DashboardLoading)
  //           return const Center(child: CircularProgressIndicator());

  //         return Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             const Text(
  //               "Dashboard Overview",
  //               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
  //             ),
  //             const SizedBox(height: 24),

  //             // عرض الكروت في Grid مرن
  //             GridView(
  //               shrinkWrap: true,
  //               gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
  //                 maxCrossAxisExtent: 300,
  //                 mainAxisExtent: 240,
  //                 crossAxisSpacing: 20,
  //                 mainAxisSpacing: 20,
  //               ),
  //               children: [
  //                 StatCard(
  //                   title: "Total Users",
  //                   value: "24,892",
  //                   change: 12.5,
  //                   icon: Icons.people,
  //                   chartColor: AppColors.primary,
  //                 ),
  //                 StatCard(
  //                   title: "Active Doctors",
  //                   value: "1,847",
  //                   change: 8.2,
  //                   icon: Icons.person_add,
  //                   chartColor: AppColors.success,
  //                 ),
  //                 StatCard(
  //                   title: "Pending Verifications",
  //                   value: "38",
  //                   change: -15.3,
  //                   icon: Icons.verified_user,
  //                   chartColor: AppColors.warning,
  //                 ),
  //                 StatCard(
  //                   title: "Open Tickets",
  //                   value: "142",
  //                   change: 5.7,
  //                   icon: Icons.confirmation_number,
  //                   chartColor: AppColors.textMuted,
  //                 ),
  //               ],
  //             ),

  //             // هنا سنضيف لاحقاً الـ Main Charts والـ Recent Activity
  //             const SizedBox(height: 24),
  //             const RegistrationTrendsChart(), // الشارت الجديد
  //             const SizedBox(height: 24),
  //             Row(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Expanded(flex: 2, child: ActivityFeed()), // تغذية النشاطات
  //                 const SizedBox(width: 24),
  //                 Expanded(flex: 1, child: PlatformHealthCard()), // صحة النظام
  //               ],
  //             ),
  //           ],
  //         );
  //       },
  //     ),
  //   );
  // }

  // lib/features/dashboard/presentation/pages/dashboard_overview_page.dart

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is DashboardFailure) {
          return Center(
            child: Text(state.errMessage),
          ); // ممكن تحط زرار Retry هنا
        } else if (state is DashboardSuccess) {
          final overview = state.overview; // الداتا الحقيقية وصلت هنا

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "System Overview",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),

                // 1. قسم الكروت (Statistics)
                _buildStatsGrid(overview),

                const SizedBox(height: 32),

                // 2. قسم الجداول (Recent Activity)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: ActivityFeed(actions: overview.recentActions),
                    ),
                    const SizedBox(width: 24),
                    // هنا ممكن تحط الـ Chart بتاعك
                    Expanded(
                      flex: 1,
                      child: RegistrationTrendsChart(
                        userStats: overview.userStats,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  // ميثود مساعدة لرسم الشبكة
  Widget _buildStatsGrid(DashboardOverviewEntity overview) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4, // 4 كروت في الويب
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      childAspectRatio: 1.5,
      children: [
        // StatCard(
        //   title: "Total Users",
        //   value: overview.userStats.totalUsers.toString(),
        //   icon: Icons.people,
        //   color: Colors.blue,
        // ),
        // StatCard(
        //   title: "Verified Doctors",
        //   value: overview.doctorStats.verifiedDoctors.toString(),
        //   icon: Icons.verified_user,
        //   color: Colors.green,
        // ),
        // StatCard(
        //   title: "Pending Verifications",
        //   value: overview.verificationStats.pendingVerifications.toString(),
        //   icon: Icons.hourglass_empty,
        //   color: Colors.orange,
        // ),
        // StatCard(
        //   title: "Open Tickets",
        //   value: overview.ticketStats.openTickets.toString(),
        //   icon: Icons.confirmation_number,
        //   color: Colors.red,
        // ),
        StatCard(
          title: "Total Users",
          value: overview.userStats.totalUsers.toString(),
          change: 12.5, // قيمة تجريبية لنسبة النمو
          icon: Icons.people_alt_rounded,
          iconColor: Colors.blue,
          chartColor: Colors.blue,
        ),
        StatCard(
          title: "Verified Doctors",
          value: overview.doctorStats.verifiedDoctors.toString(),
          change: 8.2,
          icon: Icons.verified_user_rounded,
          iconColor: Colors.teal,
          chartColor: Colors.teal,
        ),
        StatCard(
          title: "Pending Verifications",
          value: overview.verificationStats.pendingVerifications.toString(),
          icon: Icons.pending_actions_rounded,
          iconColor: Colors.orange,
          chartColor: Colors.orange,
        ),
        StatCard(
          title: "Closed Tickets",
          value: overview.ticketStats.closedTickets.toString(),
          change: -2.4, // تراجع في التذاكر المغلقة مثلاً
          icon: Icons.task_alt_rounded,
          iconColor: Colors.purple,
          chartColor: Colors.purple,
        ),
      ],
    );
  }
}
