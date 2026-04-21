// // lib/features/dashboard/presentation/widgets/activity_feed.dart
// import 'package:flutter/material.dart';
// import '../../../../core/theme/app_colors.dart';

// class ActivityFeed extends StatelessWidget {
//   const ActivityFeed({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 0,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//         side: BorderSide(color: Colors.grey.shade100),
//       ),
//       child: Column(
//         children: [
//           // Header
//           Padding(
//             padding: const EdgeInsets.all(20),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   "Recent Activity",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 _buildLiveBadge(),
//               ],
//             ),
//           ),
//           // Scrollable List
//           ConstrainedBox(
//             constraints: const BoxConstraints(maxHeight: 400),
//             child: ListView.separated(
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
//               itemCount: 6, // تقدر تربطها بالداتا من الـ Cubit لاحقاً
//               separatorBuilder: (_, __) => const SizedBox(height: 16),
//               itemBuilder: (context, index) {
//                 return _buildActivityItem();
//               },
//             ),
//           ),
//           const SizedBox(height: 20),
//         ],
//       ),
//     );
//   }

//   Widget _buildActivityItem() {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//         color: Colors.transparent,
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildStackedAvatar(),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: const [
//                     Text(
//                       "Doctor Application Approved",
//                       style: TextStyle(
//                         fontWeight: FontWeight.w600,
//                         fontSize: 14,
//                       ),
//                     ),
//                     // أيقونة التحذير لو الحالة Urgent
//                   ],
//                 ),
//                 const SizedBox(height: 4),
//                 const Text(
//                   "Dr. James Wilson has been verified and approved",
//                   style: TextStyle(color: AppColors.textMuted, fontSize: 13),
//                 ),
//                 const SizedBox(height: 6),
//                 const Text(
//                   "2 minutes ago",
//                   style: TextStyle(color: Colors.grey, fontSize: 11),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStackedAvatar() {
//     return Stack(
//       clipBehavior: Clip.none,
//       children: [
//         const CircleAvatar(
//           radius: 20,
//           backgroundColor: Color(0xFFE2E8F0),
//           child: Text(
//             "JW",
//             style: TextStyle(fontSize: 12, color: AppColors.textPrimary),
//           ),
//         ),
//         Positioned(
//           bottom: -2,
//           right: -2,
//           child: Container(
//             padding: const EdgeInsets.all(3),
//             decoration: BoxDecoration(
//               color: AppColors.success, // لون الحالة (success, urgent, etc)
//               shape: BoxShape.circle,
//               border: Border.all(color: Colors.white, width: 2),
//             ),
//             child: const Icon(Icons.check, size: 10, color: Colors.white),
//           ),
//         ),
//       ],
//     );
//   }
// lib/features/dashboard/presentation/widgets/activity_feed.dart
import 'package:admin_dashboard_graduation_project/features/dashboard/domain/entities/recent_activity_entity.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:intl/intl.dart'; // لتحسين عرض الوقت

class ActivityFeed extends StatelessWidget {
  final List<ActionEntity> actions; // استقبال قائمة الحركات الحقيقية

  const ActivityFeed({super.key, required this.actions});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Recent Activity",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                _buildLiveBadge(),
              ],
            ),
          ),

          // في حالة عدم وجود بيانات
          if (actions.isEmpty)
            const Padding(
              padding: EdgeInsets.all(20),
              child: Center(child: Text("No recent activity found")),
            )
          else
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 450),
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: actions.length,
                separatorBuilder: (_, __) =>
                    const Divider(height: 32, thickness: 0.5),
                itemBuilder: (context, index) {
                  return _buildActivityItem(actions[index]);
                },
              ),
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildActivityItem(ActionEntity action) {
    // تحديد الأيقونة واللون بناءً على نوع الحركة (Logic Mapping)
    final bool isPositive =
        action.actionType.contains("Approve") ||
        action.actionType.contains("Unblock");
    final bool isNegative =
        action.actionType.contains("Reject") ||
        action.actionType.contains("Block") ||
        action.actionType.contains("Delete");

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildActionAvatar(action.adminName, isPositive, isNegative),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _formatActionTitle(action.actionType, action.targetEntity),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "By ${action.adminName}",
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _formatTimestamp(action.timestamp),
                style: const TextStyle(color: Colors.grey, fontSize: 11),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ميثود مساعدة لتنظيف مسميات الأكشنز (مثلاً CloseTicket -> Ticket Closed)
  String _formatActionTitle(String type, String target) {
    // بنستخدم replaceAllMapped عشان نقدر نفصل الكلمات اللي لازقة في بعض
    String formattedType = type.replaceAllMapped(
      RegExp(r'([a-z])([A-Z])'),
      (Match m) => '${m[1]} ${m[2]}',
    );

    return "$target $formattedType";
  }

  // ميثود مساعدة لحساب الوقت المنقضي
  String _formatTimestamp(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) return "${diff.inMinutes} mins ago";
    if (diff.inHours < 24) return "${diff.inHours} hours ago";
    return DateFormat('MMM dd, hh:mm a').format(time);
  }

  Widget _buildActionAvatar(String name, bool positive, bool negative) {
    final initials = name
        .split(' ')
        .map((e) => e[0])
        .take(2)
        .join()
        .toUpperCase();
    return Stack(
      clipBehavior: Clip.none,
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
          child: Text(
            initials,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ),
        Positioned(
          bottom: -2,
          right: -2,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: positive
                  ? AppColors.success
                  : (negative ? AppColors.urgent : Colors.blue),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Icon(
              positive
                  ? Icons.check
                  : (negative ? Icons.close : Icons.info_outline),
              size: 10,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLiveBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          const Icon(Icons.access_time, size: 12, color: Colors.grey),
          const SizedBox(width: 4),
          Text(
            "Live",
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
