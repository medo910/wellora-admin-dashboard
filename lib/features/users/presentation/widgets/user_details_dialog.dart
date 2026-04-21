// // lib/features/users/presentation/widgets/user_details_dialog.dart
// import 'package:admin_dashboard_graduation_project/features/users/domain/entities/user_entity.dart';
// import 'package:admin_dashboard_graduation_project/features/users/domain/entities/user_status_details_entity.dart';
// import 'package:admin_dashboard_graduation_project/features/users/presentation/manager/cubit/users_cubit.dart';
// import 'package:admin_dashboard_graduation_project/features/users/presentation/widgets/role_badge.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// // void showUserDetailsDialog(BuildContext context, UserEntity user) {
// //   showDialog(
// //     context: context,
// //     builder: (context) => Dialog(
// //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
// //       child: Container(
// //         padding: const EdgeInsets.all(24),
// //         width: 400,
// //         child: Column(
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             Row(
// //               children: [
// //                 CircleAvatar(
// //                   radius: 30,
// //                   backgroundColor: Colors.teal.withOpacity(0.1),
// //                   child: Text(
// //                     user.fullName.substring(0, 1).toUpperCase(),
// //                     style: const TextStyle(fontSize: 20, color: Colors.teal),
// //                   ),
// //                 ),
// //                 const SizedBox(width: 16),
// //                 Expanded(
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Text(
// //                         user.fullName,
// //                         style: const TextStyle(
// //                           fontSize: 18,
// //                           fontWeight: FontWeight.bold,
// //                         ),
// //                       ),
// //                       const SizedBox(height: 8),
// //                       Row(
// //                         children: [
// //                           RoleBadge(type: user.userType),
// //                           const SizedBox(width: 8),
// //                           // هنا تنادي الـ StatusBadge اللي عملناها سوا
// //                         ],
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ],
// //             ),
// //             const Divider(height: 32),
// //             _buildInfoRow(Icons.email_outlined, user.email),
// //             _buildInfoRow(Icons.phone_outlined, user.phoneNumber ?? "N/A"),
// //             _buildInfoRow(
// //               Icons.calendar_month_outlined,
// //               "Joined ${user.createdAt.substring(0, 10)}",
// //             ),
// //             const SizedBox(height: 24),
// //             SizedBox(
// //               width: double.infinity,
// //               child: OutlinedButton(
// //                 onPressed: () => Navigator.pop(context),
// //                 child: const Text("Close"),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     ),
// //   );
// // }

// // Widget _buildInfoRow(IconData icon, String text) {
// //   return Padding(
// //     padding: const EdgeInsets.symmetric(vertical: 8),
// //     child: Row(
// //       children: [
// //         Icon(icon, size: 18, color: Colors.grey),
// //         const SizedBox(width: 12),
// //         Text(text, style: const TextStyle(color: Colors.black87)),
// //       ],
// //     ),
// //   );
// // }

// // lib/features/users/presentation/widgets/user_details_dialog.dart

// // lib/features/users/presentation/widgets/user_details_dialog.dart

// // الميثود الأساسية
// void showUserDetailsDialog(BuildContext context, UserEntity user) {
//   showDialog(
//     context: context,
//     builder: (context) => _UserDetailsDialogContent(user: user),
//   );
// }

// class _UserDetailsDialogContent extends StatelessWidget {
//   final UserEntity user;
//   const _UserDetailsDialogContent({required this.user});

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Container(
//         width: 550, // عرض مناسب للويب
//         padding: const EdgeInsets.all(24),
//         child: FutureBuilder<UserStatusDetailsEntity>(
//           // بننادي الميثود اللي لسه عاملنها في الكيوبت
//           future: context.read<UsersCubit>().fetchUserStatus(user.userId),
//           builder: (context, snapshot) {
//             return SingleChildScrollView(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _DetailsHeader(user: user),
//                   const Divider(height: 40),

//                   // قسم المعلومات الأساسية
//                   _buildSectionTitle("General Information"),
//                   _buildInfoGrid([
//                     _InfoTile(Icons.email_outlined, "Email", user.email),
//                     _InfoTile(
//                       Icons.phone_outlined,
//                       "Phone",
//                       user.phoneNumber ?? "Not Provided",
//                     ),
//                     _InfoTile(
//                       Icons.calendar_today_outlined,
//                       "Joined",
//                       user.createdAt.substring(0, 10),
//                     ),
//                   ]),

//                   const SizedBox(height: 24),

//                   // قسم معلومات الدكتور أو المريض (حسب النوع)
//                   if (user.userType == UserType.doctor)
//                     _buildDoctorSection(user)
//                   else
//                     _buildPatientSection(user),

//                   // قسم العقوبات (بيظهر فقط لو اليوزر Blocked أو Suspended)
//                   if (user.isBlocked || user.isSuspended) ...[
//                     const SizedBox(height: 24),
//                     _PenaltySection(
//                       user: user,
//                       details: snapshot.data,
//                       isLoading:
//                           snapshot.connectionState == ConnectionState.waiting,
//                     ),
//                   ],

//                   const SizedBox(height: 32),
//                   _buildCloseButton(context),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   // --- Widgets مساعدة سريعة ---
//   Widget _buildSectionTitle(String title) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: Text(
//         title,
//         style: const TextStyle(
//           fontSize: 16,
//           fontWeight: FontWeight.bold,
//           color: Colors.teal,
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoGrid(List<Widget> children) {
//     return Wrap(spacing: 40, runSpacing: 20, children: children);
//   }

//   Widget _buildCloseButton(BuildContext context) {
//     return SizedBox(
//       width: double.infinity,
//       child: ElevatedButton(
//         onPressed: () => Navigator.pop(context),
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.grey.shade100,
//           foregroundColor: Colors.black87,
//           elevation: 0,
//         ),
//         child: const Text("Close"),
//       ),
//     );
//   }
// }

// class _DetailsHeader extends StatelessWidget {
//   final UserEntity user;
//   const _DetailsHeader({required this.user});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         CircleAvatar(
//           radius: 35,
//           backgroundColor: Colors.teal.withOpacity(0.1),
//           child: Text(
//             user.fullName.substring(0, 1).toUpperCase(),
//             style: const TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//               color: Colors.teal,
//             ),
//           ),
//         ),
//         const SizedBox(width: 20),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 user.fullName,
//                 style: const TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Row(
//                 children: [
//                   RoleBadge(type: user.userType),
//                   const SizedBox(width: 8),
//                   StatusBadge(
//                     isBlocked: user.isBlocked,
//                     isSuspended: user.isSuspended,
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _PenaltySection extends StatelessWidget {
//   final UserEntity user;
//   final UserStatusDetailsEntity? details;
//   final bool isLoading;

//   const _PenaltySection({
//     required this.user,
//     this.details,
//     required this.isLoading,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final bool isBlocked = user.isBlocked;
//     final Color color = isBlocked ? Colors.red : Colors.orange;

//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.05),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: color.withOpacity(0.2)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(
//                 isBlocked ? Icons.gavel_rounded : Icons.timer_rounded,
//                 color: color,
//                 size: 20,
//               ),
//               const SizedBox(width: 8),
//               Text(
//                 isBlocked ? "Blocking Details" : "Suspension Details",
//                 style: TextStyle(color: color, fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           if (isLoading)
//             const LinearProgressIndicator()
//           else if (details != null) ...[
//             _PenaltyRow(
//               "Reason",
//               isBlocked ? details!.blockReason : details!.suspensionReason,
//             ),
//             _PenaltyRow(
//               "By Admin",
//               isBlocked
//                   ? details!.blockedByAdminName
//                   : details!.suspendedByAdminName,
//             ),
//             _PenaltyRow(
//               isBlocked ? "Date" : "Ends At",
//               isBlocked
//                   ? details!.blockedAt?.substring(0, 10)
//                   : details!.suspensionEndDate?.substring(0, 10),
//             ),
//           ] else
//             const Text("No details found for this action."),
//         ],
//       ),
//     );
//   }
// }

// Widget _PenaltyRow(String label, String? value) {
//   return Padding(
//     padding: const EdgeInsets.only(bottom: 8),
//     child: Row(
//       children: [
//         Text(
//           "$label: ",
//           style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
//         ),
//         Text(value ?? "N/A", style: const TextStyle(fontSize: 13)),
//       ],
//     ),
//   );
// }

// class _InfoTile extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final String value;

//   const _InfoTile(this.icon, this.label, this.value);

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 150,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(icon, size: 16, color: Colors.grey),
//               const SizedBox(width: 6),
//               Text(
//                 label,
//                 style: const TextStyle(color: Colors.grey, fontSize: 12),
//               ),
//             ],
//           ),
//           const SizedBox(height: 4),
//           Text(
//             value,
//             style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
//             overflow: TextOverflow.ellipsis,
//           ),
//         ],
//       ),
//     );
//   }
// }
