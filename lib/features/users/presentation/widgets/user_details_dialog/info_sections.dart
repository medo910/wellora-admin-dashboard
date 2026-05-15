import 'package:flutter/material.dart';
import '../../../domain/entities/user_entity.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.teal,
      ),
    );
  }
}

class InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const InfoTile(this.icon, this.label, this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: Colors.grey),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class GeneralInfoSection extends StatelessWidget {
  final UserEntity user;
  const GeneralInfoSection({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 40,
      runSpacing: 20,
      children: [
        InfoTile(Icons.email_outlined, "Email Address", user.email),
        InfoTile(
          Icons.phone_outlined,
          "Phone Number",
          user.phoneNumber ?? "N/A",
        ),
        InfoTile(
          Icons.access_time,
          "Created At",
          user.createdAt.substring(0, 10),
        ),
      ],
    );
  }
}

class DoctorInfoSection extends StatelessWidget {
  final UserEntity user;
  const DoctorInfoSection({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: "Professional Information"),
        const SizedBox(height: 12),
        Wrap(
          spacing: 40,
          children: [
            InfoTile(
              Icons.medical_services_outlined,
              "Specialization",
              user.specialization ?? "General",
            ),
            InfoTile(
              Icons.verified_outlined,
              "Verification Status",
              user.isVerified == true ? "Verified" : "Pending",
            ),
          ],
        ),
      ],
    );
  }
}

class PatientInfoSection extends StatelessWidget {
  final UserEntity user;
  const PatientInfoSection({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: "Medical Information"),
        const SizedBox(height: 12),
        InfoTile(
          Icons.bloodtype_outlined,
          "Blood Type",
          user.bloodType ?? "Not Specified",
        ),
      ],
    );
  }
}
