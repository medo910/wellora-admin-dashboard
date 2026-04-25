// // lib/features/dashboard/presentation/widgets/platform_health_card.dart
// import 'package:admin_dashboard_graduation_project/core/theme/app_colors.dart';
// import 'package:flutter/material.dart';

// class PlatformHealthCard extends StatelessWidget {
//   const PlatformHealthCard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 0,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//         side: BorderSide(color: Colors.grey.shade100),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               "Platform Health",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 20),
//             _buildHealthItem(
//               "System Status",
//               "Operational",
//               AppColors.success,
//               isBadge: true,
//             ),
//             _buildHealthItem("API Response", "45ms", AppColors.success),
//             _buildHealthItem("Database Load", "72%", AppColors.warning),
//             _buildHealthItem("Uptime (30d)", "99.98%", AppColors.success),
//             _buildHealthItem(
//               "Critical Alerts",
//               "2",
//               AppColors.urgent,
//               isBadge: true,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildHealthItem(
//     String label,
//     String value,
//     Color color, {
//     bool isBadge = false,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: Container(
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: Colors.grey.shade50,
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Row(
//               children: [
//                 Container(
//                   width: 8,
//                   height: 8,
//                   decoration: BoxDecoration(
//                     color: color,
//                     shape: BoxShape.circle,
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Text(label, style: const TextStyle(fontSize: 13)),
//               ],
//             ),
//             isBadge
//                 ? Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 8,
//                       vertical: 2,
//                     ),
//                     decoration: BoxDecoration(
//                       color: color.withValues(alpha: 0.1),
//                       borderRadius: BorderRadius.circular(4),
//                     ),
//                     child: Text(
//                       value,
//                       style: TextStyle(
//                         color: color,
//                         fontSize: 12,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   )
//                 : Text(
//                     value,
//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 13,
//                     ),
//                   ),
//           ],
//         ),
//       ),
//     );
//   }
// }
