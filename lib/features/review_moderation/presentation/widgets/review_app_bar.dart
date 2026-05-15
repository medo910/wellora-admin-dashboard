import 'package:admin_dashboard_graduation_project/features/review_moderation/presentation/manager/review_moderation_cubit/review_moderation_cubit.dart';
import 'package:admin_dashboard_graduation_project/features/review_moderation/presentation/widgets/review_filter_sheet.dart';
import 'package:admin_dashboard_graduation_project/features/review_moderation/presentation/widgets/tab_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReviewAppBar extends StatelessWidget {
  const ReviewAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      pinned: true,
      title: const Text("Review Moderation"),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.tune),
                onPressed: () => _openAdvancedFilters(context),
              ),
              const Expanded(child: _ReviewTabs()),
            ],
          ),
        ),
      ),
    );
  }

  void _openAdvancedFilters(BuildContext context) {
    final state = context.read<ReviewModerationCubit>().state;

    if (state is ReviewSuccess) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (_) => BlocProvider.value(
          value: context.read<ReviewModerationCubit>(),
          child: ReviewFilterSheet(
            initialDoctorId: state.currentDoctorId,
            initialUserId: state.currentUserId,
            initialMinR: state.minRating,
            initialMaxR: state.maxRating,
            initialDateRange: state.currentDateRange,
          ),
        ),
      );
    }
  }
}

class _ReviewTabs extends StatelessWidget {
  const _ReviewTabs();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ReviewModerationCubit>().state;
    bool isDeleted = state is ReviewSuccess ? state.isShowingDeleted : false;

    return Row(
      children: [
        TabItem(
          label: "Active",
          isActive: !isDeleted,
          onTap: () => context.read<ReviewModerationCubit>().fetchReviews(
            isDeletedTab: false,
          ),
        ),
        const SizedBox(width: 12),
        TabItem(
          label: "Deleted",
          isActive: isDeleted,
          onTap: () => context.read<ReviewModerationCubit>().fetchReviews(
            isDeletedTab: true,
          ),
        ),
      ],
    );
  }
}
