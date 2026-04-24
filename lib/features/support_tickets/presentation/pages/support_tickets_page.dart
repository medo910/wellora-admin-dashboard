// support_tickets_page.dart
import 'package:admin_dashboard_graduation_project/features/support_tickets/domain/entities/support_stats_entity.dart';
import 'package:admin_dashboard_graduation_project/features/support_tickets/presentation/manager/support_cubit/support_cubit.dart';
import 'package:admin_dashboard_graduation_project/features/support_tickets/presentation/widget/stat_card.dart';
import 'package:admin_dashboard_graduation_project/features/support_tickets/presentation/widget/support_category_insights.dart';
import 'package:admin_dashboard_graduation_project/features/support_tickets/presentation/widget/support_header.dart';
import 'package:admin_dashboard_graduation_project/features/support_tickets/presentation/widget/support_pagination_bar.dart';
import 'package:admin_dashboard_graduation_project/features/support_tickets/presentation/widget/support_search_bar.dart';
import 'package:admin_dashboard_graduation_project/features/support_tickets/presentation/widget/support_stats_grid.dart';
import 'package:admin_dashboard_graduation_project/features/support_tickets/presentation/widget/support_tabs_bar.dart';
import 'package:admin_dashboard_graduation_project/features/support_tickets/presentation/widget/support_tickets_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// class SupportTicketsPage extends StatelessWidget {
//   const SupportTicketsPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF9FAFB),
//       body: BlocBuilder<SupportCubit, SupportState>(
//         builder: (context, state) {
//           if (state is SupportLoading)
//             return const Center(child: CircularProgressIndicator());
//           if (state is SupportFailure)
//             return Center(child: Text(state.errorMessage));

//           if (state is SupportSuccess) {
//             return SingleChildScrollView(
//               padding: const EdgeInsets.all(24.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SupportHeader(urgentCount: state.stats.urgentTickets),
//                   const SizedBox(height: 24),
//                   SupportStatsGrid(stats: state.stats),
//                   const SizedBox(height: 24),
//                   const SupportSearchBar(),
//                   const SizedBox(height: 24),
//                   SupportTabsBar(currentStatus: state.currentStatus),
//                   const SizedBox(height: 16),
//                   SupportTicketsListView(tickets: state.tickets),
//                   const SizedBox(height: 24),
//                   SupportPaginationBar(state: state),
//                 ],
//               ),
//             );
//           }
//           return const SizedBox();
//         },
//       ),
//     );
//   }
// }

class SupportTicketsPage extends StatelessWidget {
  const SupportTicketsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: BlocBuilder<SupportCubit, SupportState>(
        builder: (context, state) {
          if (state is SupportLoading)
            return const Center(child: CircularProgressIndicator());
          if (state is SupportFailure)
            return Center(child: Text(state.errorMessage));

          if (state is SupportSuccess) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SupportHeader(urgentCount: state.stats.urgentTickets),
                  const SizedBox(height: 24),

                  SupportStatsGrid(stats: state.stats),
                  const SizedBox(height: 24),

                  // 🚀 الإضافة الجديدة: إحصائيات الأقسام
                  SupportCategoryInsights(
                    categories: state.stats.ticketsByCategory,
                  ),
                  const SizedBox(height: 24),

                  const SupportSearchBar(),
                  const SizedBox(height: 24),

                  SupportTabsBar(currentStatus: state.currentStatus),
                  const SizedBox(height: 16),

                  SupportTicketsListView(tickets: state.tickets),
                  const SizedBox(height: 24),

                  // 🚀 الباجنيشن في الآخر
                  SupportPaginationBar(state: state),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
