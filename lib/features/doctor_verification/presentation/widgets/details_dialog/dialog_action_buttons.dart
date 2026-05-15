import 'package:admin_dashboard_graduation_project/features/doctor_verification/domain/entities/doctor_verification_entity.dart';
import 'package:admin_dashboard_graduation_project/features/doctor_verification/presentation/widgets/details_dialog/verification_details_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../manager/doctor_verification_cubit/doctor_verification_cubit.dart';

class DialogActionButtons extends StatelessWidget {
  final DoctorVerificationEntity doctor;
  const DialogActionButtons({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
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

void showApprovePrompt(
  BuildContext context,
  DoctorVerificationEntity doctor, {
  bool isFromDetails = false,
}) {
  final TextEditingController notesController = TextEditingController(
    text: "Documents verified",
  );

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
            cubit.approveDoc(doctor.doctorId, notesController.text);

            Navigator.pop(confirmContext);
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
