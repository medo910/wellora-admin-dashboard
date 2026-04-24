import 'package:admin_dashboard_graduation_project/features/doctor_verification/presentation/widgets/details_dialog/profile_avatar.dart';
import 'package:admin_dashboard_graduation_project/features/doctor_verification/presentation/widgets/details_dialog/profile_info_grid.dart';
import 'package:admin_dashboard_graduation_project/features/doctor_verification/presentation/widgets/details_dialog/status_alerts_section.dart';
import 'package:flutter/material.dart';
import '../../../domain/entities/doctor_verification_entity.dart';

// class DoctorProfileSection extends StatelessWidget {
//   final DoctorVerificationEntity doctor;
//   const DoctorProfileSection({super.key, required this.doctor});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         CircleAvatar(
//           radius: 38,
//           backgroundColor: const Color(0xFFF1F5F9),
//           child: Text(
//             doctor.doctorName.substring(0, 2).toUpperCase(),
//             style: const TextStyle(
//               color: Color(0xFF64748B),
//               fontWeight: FontWeight.bold,
//               fontSize: 22,
//             ),
//           ),
//         ),
//         const SizedBox(width: 24),
//         Expanded(
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start, // عشان يبدأ من فوق
//             children: [
//               _buildInfoColumn("CONTACT", [
//                 _infoRow(Icons.email_outlined, doctor.doctorEmail),
//                 _infoRow(Icons.phone_outlined, doctor.phoneNumber ?? "N/A"),
//                 _infoRow(
//                   Icons.location_on_outlined,
//                   doctor.clinicLocation ?? "No Location",
//                 ),
//               ]),
//               const SizedBox(width: 40),
//               _buildInfoColumn("PROFESSIONAL", [
//                 _infoRow(Icons.business_outlined, doctor.specialization),
//                 _infoRow(
//                   Icons.work_outline,
//                   "${doctor.yearsOfExperience} years exp.",
//                 ),
//                 _infoRow(Icons.calendar_today_outlined, "Applied 3/14/2026"),
//               ], showBadge: doctor.overallStatus == "Approved"),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildInfoColumn(
//     String title,
//     List<Widget> items, {
//     bool showBadge = false,
//   }) {
//     return Expanded(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 title,
//                 style: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 12,
//                   color: Colors.grey,
//                   letterSpacing: 1.1,
//                 ),
//               ),
//               // 💡 ظهور البادج الأخضر هنا
//               if (showBadge)
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 8,
//                     vertical: 4,
//                   ),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFDCFCE7),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: const Row(
//                     children: [
//                       Icon(
//                         Icons.check_circle,
//                         color: Color(0xFF166534),
//                         size: 12,
//                       ),
//                       SizedBox(width: 4),
//                       Text(
//                         "Approved",
//                         style: TextStyle(
//                           color: Color(0xFF166534),
//                           fontSize: 10,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           ...items,
//         ],
//       ),
//     );
//   }

//   Widget _infoRow(IconData icon, String text) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 10),
//       child: Row(
//         children: [
//           Icon(icon, size: 16, color: Colors.grey.shade400),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Text(
//               text,
//               style: const TextStyle(fontSize: 14, color: Color(0xFF334155)),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// lib/features/doctor_verification/presentation/widgets/details_dialog/doctor_profile_section.dart

class DoctorProfileSection extends StatelessWidget {
  final DoctorVerificationEntity doctor;
  const DoctorProfileSection({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. الأفاتار (مفصول)
            ProfileAvatar(name: doctor.doctorName),
            const SizedBox(width: 24),
            // 2. شبكة البيانات (مفصول)
            Expanded(child: ProfileInfoGrid(doctor: doctor)),
          ],
        ),
        // 3. قسم التنبيهات: رفض، ورق ناقص، مراجع (مفصول)
        StatusAlertsSection(doctor: doctor),
      ],
    );
  }
}
