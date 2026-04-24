import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String name;
  const ProfileAvatar({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 38,
      backgroundColor: const Color(0xFFF1F5F9),
      child: Text(
        name.substring(0, 2).toUpperCase(),
        style: const TextStyle(
          color: Color(0xFF64748B),
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
    );
  }
}
