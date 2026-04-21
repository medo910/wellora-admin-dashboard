import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/doctor_verification_entity.dart';
import '../../manager/doctor_verification_cubit/doctor_verification_cubit.dart';
import 'doctor_profile_section.dart';
import 'documents_list_section.dart';
import 'dialog_action_buttons.dart';

void showVerificationDetailsDialog(
  BuildContext context,
  DoctorVerificationEntity doctor,
) {
  showDialog(
    context: context,
    builder: (dialogContext) => BlocProvider.value(
      value: context.read<DoctorVerificationCubit>(),
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 850,
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDialogHeader(dialogContext),
              const SizedBox(height: 24),
              DoctorProfileSection(doctor: doctor),
              const SizedBox(height: 32),
              DocumentsListSection(documents: doctor.documents),
              const SizedBox(height: 32),
              DialogActionButtons(doctor: doctor),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget _buildDialogHeader(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Application Details",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          Text(
            "Review all submitted information and documents",
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ],
      ),
      IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.close),
      ),
    ],
  );
}

void showRejectPrompt(BuildContext context, int doctorId) {
  final TextEditingController reasonController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.report_problem_outlined, color: Colors.red),
          SizedBox(width: 8),
          Text("Reject Application"),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Please specify why you are rejecting this doctor's documents. The doctor will see this reason.",
          ),
          const SizedBox(height: 16),
          TextField(
            controller: reasonController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: "Rejection Reason (Required)",
              hintText: "e.g., ID is expired or blurred...",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: notesController,
            decoration: const InputDecoration(
              labelText: "Admin Private Notes (Optional)",
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () {
            if (reasonController.text.trim().isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Please provide a reason")),
              );
              return;
            }
            // بننادي الكيوبت بتاعنا
            context.read<DoctorVerificationCubit>().rejectDoc(
              doctorId,
              reasonController.text,
              notesController.text,
            );
            Navigator.pop(dialogContext); // قفل دايلوج الرفض
            Navigator.pop(context); // قفل دايلوج التفاصيل الأساسي
          },
          child: const Text(
            "Confirm Rejection",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    ),
  );
}
