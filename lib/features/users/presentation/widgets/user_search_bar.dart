import 'package:flutter/material.dart';

class UserSearchBar extends StatelessWidget {
  final Function(String) onSearch;
  const UserSearchBar({super.key, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      child: TextField(
        onChanged: onSearch,
        decoration: InputDecoration(
          hintText: "Search users by name or email...",
          prefixIcon: const Icon(Icons.search, size: 20),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }
}
