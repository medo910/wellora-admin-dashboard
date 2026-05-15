import 'package:admin_dashboard_graduation_project/features/users/presentation/manager/cubit/users_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user_entity.dart';

void _showActionWithReasonDialog({
  required BuildContext context,
  required String title,
  required String confirmLabel,
  required Color color,
  required Function(String reason) onConfirm,
}) {
  final controller = TextEditingController();

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Please provide a reason for this action:"),
          const SizedBox(height: 16),
          TextField(
            controller: controller,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: "Enter reason here...",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            onConfirm(controller.text);
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
          ),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
}

void _showSimpleConfirmDialog({
  required BuildContext context,
  required String title,
  required String confirmLabel,
  required Color color,
  required VoidCallback onConfirm,
}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      content: Text("Are you sure you want to $confirmLabel this user?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            onConfirm();
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
          ),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
}

void showBlockUserDialog(BuildContext context, UserEntity user) {
  bool isCurrentlyBlocked = user.isBlocked;

  if (isCurrentlyBlocked) {
    _showSimpleConfirmDialog(
      context: context,
      title: "Unblock ${user.fullName}",
      confirmLabel: "Unblock",
      color: Colors.teal,
      onConfirm: () => context.read<UsersCubit>().unblockUser(user.userId),
    );
  } else {
    _showActionWithReasonDialog(
      context: context,
      title: "Block ${user.fullName}",
      confirmLabel: "Block",
      color: Colors.red,
      onConfirm: (reason) =>
          context.read<UsersCubit>().blockUser(user.userId, reason),
    );
  }
}

Future<void> showSuspendUserDialog(
  BuildContext context,
  UserEntity user,
) async {
  bool isCurrentlySuspended = user.isSuspended;

  if (isCurrentlySuspended) {
    _showSimpleConfirmDialog(
      context: context,
      title: "Unsuspend ${user.fullName}",
      confirmLabel: "Unsuspend",
      color: Colors.teal,
      onConfirm: () => context.read<UsersCubit>().unsuspendUser(user.userId),
    );
  } else {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null) {
      _showActionWithReasonDialog(
        context: context,
        title: "Suspend ${user.fullName}",
        confirmLabel: "Suspend",
        color: Colors.orange,
        onConfirm: (reason) => context.read<UsersCubit>().suspendUser(
          user.userId,
          reason,
          pickedDate.toIso8601String(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Suspension cancelled: No end date selected."),
          backgroundColor: Colors.grey,
        ),
      );
    }
  }
}
