// // // lib/features/doctor_verification/presentation/widgets/doctor_verification_card.dart

// import 'package:admin_dashboard_graduation_project/features/doctor_verification/domain/entities/doctor_verification_entity.dart';
// import 'package:admin_dashboard_graduation_project/features/doctor_verification/presentation/manager/doctor_verification_cubit/doctor_verification_cubit.dart';
// import 'package:admin_dashboard_graduation_project/features/doctor_verification/presentation/widgets/details_dialog/verification_details_dialog.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class _StatusBadge extends StatelessWidget {
//   final String status;
//   const _StatusBadge({required this.status});

//   @override
//   Widget build(BuildContext context) {
//     Color color = status == "Approved"
//         ? Colors.green
//         : (status == "Rejected" ? Colors.red : Colors.orange);
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//       decoration: BoxDecoration(
//         color: color.withValues(alpha: 0.1),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Text(
//         status,
//         style: TextStyle(
//           color: color,
//           fontSize: 12,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }
// }

// class DoctorVerificationCard extends StatelessWidget {
//   final DoctorVerificationEntity doctor;
//   const DoctorVerificationCard({super.key, required this.doctor});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 0.5,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//         side: BorderSide(color: Colors.grey.shade200),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // _buildHeader(),
//             // const SizedBox(height: 20),
//             // _buildInfoGrid(), // شبكة المعلومات الجديدة
//             // const SizedBox(height: 20),
//             // _buildDocsTags(), // الوثائق المرفوعة
//             // const Spacer(),
//             // _buildFooterActions(context), // الزراير الجديدة
//             _buildHeader(),
//             const SizedBox(height: 16),
//             _buildInfoGrid(),
//             const SizedBox(height: 16),
//             const Text(
//               "Documents:",
//               style: TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.grey,
//               ),
//             ),
//             const SizedBox(height: 8),
//             _buildDocsTags(),
//             // شيلنا الـ Spacer والـ Divider الكبير
//             const SizedBox(height: 24),
//             _buildFooterActions(context),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return Row(
//       children: [
//         CircleAvatar(
//           radius: 24,
//           backgroundColor: Colors.teal.withValues(alpha: 0.1),
//           child: Text(
//             doctor.doctorName[0],
//             style: const TextStyle(
//               color: Colors.teal,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 doctor.doctorName,
//                 style: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 17,
//                 ),
//               ),
//               Text(
//                 doctor.specialization,
//                 style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
//               ),
//             ],
//           ),
//         ),
//         _StatusBadge(status: doctor.overallStatus),
//       ],
//     );
//   }

//   Widget _buildInfoGrid() {
//     return GridView(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         childAspectRatio: 4,
//         crossAxisSpacing: 10,
//         mainAxisSpacing: 10,
//       ),
//       children: [
//         _infoItem(Icons.email_outlined, doctor.doctorEmail),
//         _infoItem(
//           Icons.location_on_outlined,
//           doctor.clinicLocation ?? "No Location",
//         ),
//         _infoItem(Icons.work_outline, "${doctor.yearsOfExperience} years exp."),
//         _infoItem(
//           Icons.calendar_today_outlined,
//           _formatDate(doctor.submittedAt),
//         ),
//       ],
//     );
//   }

//   Widget _infoItem(IconData icon, String text) {
//     return Row(
//       children: [
//         Icon(icon, size: 16, color: Colors.grey.shade500),
//         const SizedBox(width: 8),
//         Expanded(
//           child: Text(
//             text,
//             style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
//             overflow: TextOverflow.ellipsis,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildDocsTags() {
//     return Wrap(
//       spacing: 8,
//       runSpacing: 8,
//       children: doctor.documents
//           .map(
//             (doc) => Container(
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade50,
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(color: Colors.grey.shade100),
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Icon(
//                     Icons.file_copy_outlined,
//                     size: 14,
//                     color: Colors.grey,
//                   ),
//                   const SizedBox(width: 6),
//                   Text(
//                     doc.documentType,
//                     style: const TextStyle(fontSize: 12, color: Colors.black87),
//                   ),
//                 ],
//               ),
//             ),
//           )
//           .toList(),
//     );
//   }

//   // Widget _buildFooterActions(BuildContext context) {
//   //   return Row(
//   //     children: [
//   //       Expanded(
//   //         flex: 3,
//   //         child: OutlinedButton.icon(
//   //           onPressed: () => showVerificationDetailsDialog(context, doctor),
//   //           icon: const Icon(Icons.visibility_outlined, size: 18),
//   //           label: const Text("View Details"),
//   //           style: OutlinedButton.styleFrom(
//   //             padding: const EdgeInsets.symmetric(vertical: 18),
//   //           ),
//   //         ),
//   //       ),
//   //       if (doctor.overallStatus == "Pending") ...[
//   //         const SizedBox(width: 8),
//   //         _actionIconButton(
//   //           icon: Icons.close,
//   //           color: Colors.red,
//   //           onTap: () => showRejectPrompt(context, doctor.doctorId),
//   //         ),
//   //         const SizedBox(width: 8),
//   //         _actionIconButton(
//   //           icon: Icons.check,
//   //           color: Colors.teal,
//   //           onTap: () => context.read<DoctorVerificationCubit>().approveDoc(
//   //             doctor.doctorId,
//   //             "Approved by Admin",
//   //           ),
//   //         ),
//   //       ],
//   //     ],
//   //   );
//   // }
//   Widget _buildFooterActions(BuildContext context) {
//     return Row(
//       children: [
//         Expanded(
//           child: OutlinedButton(
//             onPressed: () => showVerificationDetailsDialog(context, doctor),
//             style: OutlinedButton.styleFrom(
//               padding: const EdgeInsets.symmetric(vertical: 16),
//               side: BorderSide(color: Colors.grey.shade200),
//             ),
//             child: const Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(Icons.visibility_outlined, size: 18),
//                 SizedBox(width: 8),
//                 Text("View Details"),
//               ],
//             ),
//           ),
//         ),
//         if (doctor.computedStatus == "Pending") ...[
//           const SizedBox(width: 12),
//           _actionButton(
//             Icons.close,
//             Colors.red.shade600,
//             () => showRejectPrompt(context, doctor.doctorId),
//           ),
//           const SizedBox(width: 8),
//           _actionButton(
//             Icons.check,
//             Colors.teal,
//             () => context.read<DoctorVerificationCubit>().approveDoc(
//               doctor.doctorId,
//               "Verified",
//             ),
//           ),
//         ],
//       ],
//     );
//   }

//   Widget _actionButton(IconData icon, Color color, VoidCallback onTap) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(10),
//         decoration: BoxDecoration(
//           color: color,
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Icon(icon, color: Colors.white, size: 20),
//       ),
//     );
//   }

//   String _formatDate(String dateStr) {
//     try {
//       DateTime dt = DateTime.parse(dateStr);
//       // تنسيق بسيط: Mar 15
//       List<String> months = [
//         'Jan',
//         'Feb',
//         'Mar',
//         'Apr',
//         'May',
//         'Jun',
//         'Jul',
//         'Aug',
//         'Sep',
//         'Oct',
//         'Nov',
//         'Dec',
//       ];
//       return "${months[dt.month - 1]} ${dt.day}";
//     } catch (_) {
//       return dateStr;
//     }
//   }
// }

import 'package:flutter/material.dart';
import '../../domain/entities/doctor_verification_entity.dart';
import 'card_components/card_header.dart';
import 'card_components/card_info_grid.dart';
import 'card_components/card_footer_actions.dart';

class DoctorVerificationCard extends StatelessWidget {
  final DoctorVerificationEntity doctor;
  const DoctorVerificationCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. الجزء العلوي (Avatar + Name + Status)
            CardHeader(doctor: doctor),

            const SizedBox(height: 16),

            // 2. شبكة المعلومات (Email, Location, Experience, Date)
            CardInfoGrid(doctor: doctor),

            const SizedBox(height: 16),

            // 3. قسم الوثائق المرفوعة
            const Text(
              "Documents:",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            _buildDocsTags(),

            const SizedBox(height: 24),

            // 4. أزرار الأكشن (View Details + Approve/Reject)
            CardFooterActions(doctor: doctor),
          ],
        ),
      ),
    );
  }

  // ميثود Tags الوثائق (موجودة هنا لسهولتها، وممكن تفصلها لو حبيت)
  Widget _buildDocsTags() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: doctor.documents
          .map(
            (doc) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade100),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.file_copy_outlined,
                    size: 14,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    doc.documentType,
                    style: const TextStyle(fontSize: 12, color: Colors.black87),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
