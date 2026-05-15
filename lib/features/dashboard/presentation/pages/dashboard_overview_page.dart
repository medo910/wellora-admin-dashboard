import 'package:admin_dashboard_graduation_project/features/dashboard/domain/entities/dashboard_overview_entity.dart';
import 'package:admin_dashboard_graduation_project/features/dashboard/presentation/cubit/dashboard_cubit/dashboard_cubit.dart';
import 'package:admin_dashboard_graduation_project/features/dashboard/presentation/cubit/dashboard_cubit/dashboard_state.dart';
import 'package:admin_dashboard_graduation_project/features/dashboard/presentation/widgets/activity_feed.dart';
import 'package:admin_dashboard_graduation_project/features/dashboard/presentation/widgets/registration_trends_chart.dart';
import 'package:admin_dashboard_graduation_project/features/dashboard/presentation/widgets/stat_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardOverviewPage extends StatefulWidget {
  const DashboardOverviewPage({super.key});

  @override
  State<DashboardOverviewPage> createState() => _DashboardOverviewPageState();
}

class _DashboardOverviewPageState extends State<DashboardOverviewPage> {
  // @override
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is DashboardFailure) {
          return Center(child: Text(state.errMessage));
        } else if (state is DashboardSuccess) {
          final overview = state.overview;

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

                _buildStatsGrid(overview),

                const SizedBox(height: 32),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: ActivityFeed(actions: overview.recentActions),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      flex: 1,
                      child: RegistrationTrendsChart(
                        trends: overview.userRegistrationTrend,
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

  Widget _buildStatsGrid(DashboardOverviewEntity overview) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      childAspectRatio: 1.5,
      children: [
        StatCard(
          title: "Total Users",
          value: overview.userStats.totalUsers.toString(),
          trend: overview.userStats.lastSevenDaysTrend,
          change: overview.userStats.percentageChange,
          icon: Icons.people_alt_rounded,
          iconColor: Colors.blue,
          chartColor: Colors.blue,
        ),
        StatCard(
          title: "Verified Doctors",
          value: overview.doctorStats.verifiedDoctors.toString(),
          change: overview.doctorStats.percentageChange,
          icon: Icons.verified_user_rounded,
          trend: overview.doctorStats.lastSevenDaysTrend,
          iconColor: Colors.teal,
          chartColor: Colors.teal,
        ),
        StatCard(
          title: "Pending Verifications",
          value: overview.doctorStats.pendingVerification.toString(),
          icon: Icons.pending_actions_rounded,
          change: overview.verificationStats.percentageChange,
          trend: overview.verificationStats.lastSevenDaysTrend,
          iconColor: Colors.orange,
          chartColor: Colors.orange,
        ),
        StatCard(
          title: "Closed Tickets",
          value: overview.ticketStats.closedTickets.toString(),
          icon: Icons.task_alt_rounded,
          change: overview.ticketStats.percentageChange,
          trend: overview.ticketStats.lastSevenDaysTrend,
          iconColor: Colors.purple,
          chartColor: Colors.purple,
        ),
      ],
    );
  }
}
