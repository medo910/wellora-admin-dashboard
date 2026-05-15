import 'package:flutter/material.dart';

class DeleteReviewDialog extends StatefulWidget {
  final Function(String reason) onConfirm;
  const DeleteReviewDialog({super.key, required this.onConfirm});

  @override
  State<DeleteReviewDialog> createState() => _DeleteReviewDialogState();
}

class _DeleteReviewDialogState extends State<DeleteReviewDialog> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Delete Review"),
      content: TextField(
        controller: _controller,
        maxLines: 3,
        decoration: const InputDecoration(
          hintText:
              "Why are you deleting this review? (e.g. Offensive language)",
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () {
            if (_controller.text.isNotEmpty) {
              widget.onConfirm(_controller.text);
              Navigator.pop(context);
            }
          },
          child: const Text(
            "Confirm Delete",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
