import 'package:admin_dashboard_graduation_project/features/doctor_verification/domain/entities/doctor_verification_entity.dart';
import 'package:admin_dashboard_graduation_project/features/doctor_verification/presentation/widgets/details_dialog/verification_details_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../manager/doctor_verification_cubit/doctor_verification_cubit.dart';

// lib/features/doctor_verification/presentation/widgets/details_dialog/dialog_action_buttons.dart

class DialogActionButtons extends StatelessWidget {
  final DoctorVerificationEntity
  doctor; // غيرنا الـ ID للكائن كله عشان نعرف الحالة
  const DialogActionButtons({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    // 💡 التحقق من الحالة
    final bool isApproved =
        doctor.overallStatus == "Approved" ||
        doctor.overallStatus == "Rejected";

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
              // Navigator.pop(context);
              showRejectPrompt(context, doctor.doctorId, isFromDetails: true);
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
            onPressed: doctor.isReadyForReview
                ? () {
                    showApprovePrompt(context, doctor, isFromDetails: true);
                  }
                : null,
            child: Text(
              doctor.isReadyForReview
                  ? "Approve Doctor"
                  : "Incomplete Application",
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

// void _showApprovePrompt(BuildContext context, DoctorVerificationEntity doctor) {
//   final TextEditingController notesController = TextEditingController(
//     text: "Documents verified",
//   );

//   showDialog(
//     context: context,
//     builder: (confirmContext) => AlertDialog(
//       title: const Text("Confirm Approval"),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text("Are you sure you want to approve Dr. ${doctor.doctorName}?"),
//           const SizedBox(height: 16),
//           TextField(
//             controller: notesController,
//             decoration: const InputDecoration(
//               labelText: "Admin Notes (Optional)",
//               border: OutlineInputBorder(),
//               hintText: "Add any notes for the doctor...",
//             ),
//             maxLines: 2,
//           ),
//         ],
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(confirmContext),
//           child: const Text("Cancel"),
//         ),
//         ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             backgroundColor: const Color(0xFF0D9488),
//           ),
//           onPressed: () {
//             // نستخدم الـ context الأصلي عشان الـ Cubit
//             context.read<DoctorVerificationCubit>().approveDoc(
//               doctor.doctorId,
//               notesController.text,
//             );
//             Navigator.pop(confirmContext); // نقفل الـ Prompt
//             Navigator.pop(context); // نقفل دايلوج التفاصيل
//           },
//           child: const Text(
//             "Confirm & Approve",
//             style: TextStyle(color: Colors.white),
//           ),
//         ),
//       ],
//     ),
//   );
// }

void showApprovePrompt(
  BuildContext context,
  DoctorVerificationEntity doctor, {
  bool isFromDetails = false,
}) {
  final TextEditingController notesController = TextEditingController(
    text: "Documents verified",
  );

  // 💡 الخطوة السحرية: بنخزن الـ Cubit في متغير هنا وهو لسه الـ context "عايش"
  final cubit = context.read<DoctorVerificationCubit>();

  showDialog(
    context: context,
    builder: (confirmContext) => AlertDialog(
      title: const Text("Confirm Approval"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Are you sure you want to approve Dr. ${doctor.doctorName}?"),
          const SizedBox(height: 16),
          TextField(
            controller: notesController,
            decoration: const InputDecoration(
              labelText: "Admin Notes (Optional)",
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(confirmContext),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0D9488),
          ),
          onPressed: () {
            // 🚀 بنستخدم المتغير اللي خطفناه فوق، مش الـ context
            cubit.approveDoc(doctor.doctorId, notesController.text);

            Navigator.pop(confirmContext); // نقفل البرومبت
            // Navigator.pop(context); // نقفل الدايلوج الرئيسي
            if (isFromDetails) {
              Navigator.pop(context);
            }
          },
          child: const Text(
            "Confirm & Approve",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    ),
  );
}
