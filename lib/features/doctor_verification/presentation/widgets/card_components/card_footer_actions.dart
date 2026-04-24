import 'package:admin_dashboard_graduation_project/features/doctor_verification/domain/entities/doctor_verification_entity.dart';
import 'package:admin_dashboard_graduation_project/features/doctor_verification/presentation/manager/doctor_verification_cubit/doctor_verification_cubit.dart';
import 'package:admin_dashboard_graduation_project/features/doctor_verification/presentation/widgets/details_dialog/dialog_action_buttons.dart';
import 'package:admin_dashboard_graduation_project/features/doctor_verification/presentation/widgets/details_dialog/verification_details_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// class CardFooterActions extends StatelessWidget {
//   final DoctorVerificationEntity doctor;
//   const CardFooterActions({super.key, required this.doctor});

//   @override
//   Widget build(BuildContext context) {
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
//         if (doctor.overallStatus == "Pending") ...[
//           const SizedBox(width: 12),
//           _actionButton(
//             Icons.close,
//             Colors.red.shade600,
//             () {} /* Reject logic */,
//           ),
//           const SizedBox(width: 8),
//           _actionButton(Icons.check, Colors.teal, () {
//             context.read<DoctorVerificationCubit>().approveDoc(
//               doctor.doctorId,
//               "Verified",
//             );
//           }),
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
// }

class CardFooterActions extends StatelessWidget {
  final DoctorVerificationEntity doctor;
  const CardFooterActions({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    // 💡 بنعرف لو الدكتور جاهز للموافقة ولا لأ
    final bool canApprove = doctor.isReadyForReview;
    final bool isPendingOrIncomplete =
        doctor.overallStatus == "Pending" ||
        doctor.overallStatus == "Incomplete";

    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => showVerificationDetailsDialog(context, doctor),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.visibility_outlined, size: 18),
                SizedBox(width: 8),
                Text("View Details"),
              ],
            ),
          ),
        ),
        // 💡 بنظهر الزراير لو الحالة لسه محتاجة أكشن
        if (isPendingOrIncomplete) ...[
          const SizedBox(width: 12),
          // زرار الرفض (شغال دايماً لو الحالة Pending)
          _actionButton(
            Icons.close,
            Colors.red.shade600,
            () => showRejectPrompt(
              context,
              doctor.doctorId,
              isFromDetails: false,
            ),
          ),
          const SizedBox(width: 8),
          // زرار القبول (بيعتمد على الجاهزية)
          _actionButton(
            Icons.check,
            canApprove ? Colors.teal : Colors.grey.shade300,
            canApprove
                ?
                  // () => context.read<DoctorVerificationCubit>().approveDoc(
                  //     doctor.doctorId,
                  //     "Verified",
                  //   )
                  () => showApprovePrompt(context, doctor, isFromDetails: false)
                : null, // تعطيل الضغط لو مش جاهز
            tooltip: canApprove ? "Approve Doctor" : "Documents Incomplete",
          ),
        ],
      ],
    );
  }

  Widget _actionButton(
    IconData icon,
    Color color,
    VoidCallback? onTap, {
    String? tooltip,
  }) {
    return Tooltip(
      message: tooltip ?? "",
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}
