import 'package:flutter/material.dart';

class UserPaginationBar extends StatelessWidget {
  final int currentPage;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  const UserPaginationBar({
    super.key,
    required this.currentPage,
    this.onPrevious,
    this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Text(
          "Page: ",
          style: TextStyle(color: Colors.grey, fontSize: 13),
        ),
        Text(
          "$currentPage",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 16),
        IconButton(
          icon: const Icon(Icons.chevron_left, size: 20),
          onPressed: onPrevious,
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right, size: 20),
          onPressed: onNext,
        ),
      ],
    );
  }
}
