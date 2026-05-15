import 'package:admin_dashboard_graduation_project/core/di/injection_container.dart';
import 'package:admin_dashboard_graduation_project/features/review_moderation/presentation/manager/review_moderation_cubit/review_moderation_cubit.dart';
import 'package:admin_dashboard_graduation_project/features/review_moderation/presentation/widgets/delete_review_dialog.dart';
import 'package:admin_dashboard_graduation_project/features/review_moderation/presentation/widgets/review_app_bar.dart';
import 'package:admin_dashboard_graduation_project/features/review_moderation/presentation/widgets/review_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReviewModerationPage extends StatelessWidget {
  const ReviewModerationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ReviewModerationCubit>()..fetchReviews(),
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        body: BlocConsumer<ReviewModerationCubit, ReviewModerationState>(
          listener: (context, state) {
            if (state is ReviewSuccess && state.actionMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.actionMessage!),
                  backgroundColor: Colors.green,
                ),
              );
            }
          },
          builder: (context, state) {
            return CustomScrollView(
              slivers: [const ReviewAppBar(), _ReviewList()],
            );
          },
        ),
      ),
    );
  }
}

void _showDeleteDialog(BuildContext context, int id) {
  showDialog(
    context: context,
    builder: (_) => DeleteReviewDialog(
      onConfirm: (reason) =>
          context.read<ReviewModerationCubit>().deleteReview(id, reason),
    ),
  );
}

void _showRestoreDialog(BuildContext context, int id) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text("Restore Review"),
      content: const Text(
        "Are you sure you want to make this review visible again?",
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          onPressed: () {
            context.read<ReviewModerationCubit>().restoreReview(id);
            Navigator.pop(ctx);
          },
          child: const Text(
            "Confirm Restore",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    ),
  );
}
// }

class _ReviewList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReviewModerationCubit, ReviewModerationState>(
      builder: (context, state) {
        if (state is ReviewLoading) {
          return const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is ReviewSuccess) {
          if (state.reviews.isEmpty) {
            return const SliverFillRemaining(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    "No reviews found matching your criteria.",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverMainAxisGroup(
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => ReviewCard(
                      review: state.reviews[index],

                      onDelete: () => _showDeleteDialog(
                        context,
                        state.reviews[index].reviewId,
                      ),
                      onRestore: () => _showRestoreDialog(
                        context,
                        state.reviews[index].reviewId,
                      ),
                    ),
                    childCount: state.reviews.length,
                  ),
                ),
                SliverToBoxAdapter(
                  child: _PaginationBar(
                    currentPage: state.currentPage,
                    hasNextPage: state.hasNextPage,
                    onPageChanged: (page) => context
                        .read<ReviewModerationCubit>()
                        .fetchReviews(page: page, isRefresh: true),
                  ),
                ),
              ],
            ),
          );
        }
        return const SliverToBoxAdapter(child: SizedBox());
      },
    );
  }
}

class _PaginationBar extends StatelessWidget {
  final int currentPage;
  final bool hasNextPage;
  final Function(int) onPageChanged;

  const _PaginationBar({
    required this.currentPage,
    required this.hasNextPage,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: currentPage > 1
                ? () => onPageChanged(currentPage - 1)
                : null,
            icon: const Icon(Icons.arrow_back_ios, size: 16),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              "Page $currentPage",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
          ),
          IconButton(
            onPressed: hasNextPage
                ? () => onPageChanged(currentPage + 1)
                : null,
            icon: const Icon(Icons.arrow_forward_ios, size: 16),
          ),
        ],
      ),
    );
  }
}
