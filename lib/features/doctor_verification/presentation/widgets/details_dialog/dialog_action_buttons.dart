import 'package:admin_dashboard_graduation_project/features/doctor_verification/domain/entities/doctor_verification_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../manager/doctor_verification_cubit/doctor_verification_cubit.dart';

// class DialogActionButtons extends StatelessWidget {
//   final int doctorId;
//   const DialogActionButtons({super.key, required this.doctorId});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.end,
//       children: [
//         TextButton(
//           onPressed: () => Navigator.pop(context),
//           child: const Text(
//             "Close",
//             style: TextStyle(color: Color(0xFF64748B)),
//           ),
//         ),
//         const SizedBox(width: 12),
//         TextButton(
//           onPressed: () {
//             // هنا بننادي دايلوج الرفض اللي عملناه قبل كدة
//             Navigator.pop(context);
//             // _showRejectPrompt(context, doctorId);
//           },
//           child: const Text("Reject", style: TextStyle(color: Colors.red)),
//         ),
//         const SizedBox(width: 12),
//         ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             backgroundColor: const Color(0xFF0D9488),
//             padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//             ),
//           ),
//           onPressed: () {
//             context.read<DoctorVerificationCubit>().approveDoc(
//               doctorId,
//               "Documents verified",
//             );
//             Navigator.pop(context);
//           },
//           child: const Text(
//             "Approve Doctor",
//             style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//           ),
//         ),
//       ],
//     );
//   }
// }

// lib/features/doctor_verification/presentation/widgets/details_dialog/dialog_action_buttons.dart

class DialogActionButtons extends StatelessWidget {
  final DoctorVerificationEntity
  doctor; // غيرنا الـ ID للكائن كله عشان نعرف الحالة
  const DialogActionButtons({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    // 💡 التحقق من الحالة
    final bool isApproved = doctor.overallStatus == "Approved";

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            "Close",
            style: TextStyle(color: Color(0xFF64748B)),
          ),
        ),
        // 💡 لو مش Approved، اظهر زراير الأكشن
        if (!isApproved) ...[
          const SizedBox(width: 12),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // _showRejectPrompt(context, doctor.doctorId);
            },
            child: const Text("Reject", style: TextStyle(color: Colors.red)),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0D9488),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              context.read<DoctorVerificationCubit>().approveDoc(
                doctor.doctorId,
                "Verified",
              );
              Navigator.pop(context);
            },
            child: const Text(
              "Approve Doctor",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
