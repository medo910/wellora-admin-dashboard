import 'package:admin_dashboard_graduation_project/features/doctor_verification/presentation/widgets/details_dialog/profile_avatar.dart';
import 'package:admin_dashboard_graduation_project/features/doctor_verification/presentation/widgets/details_dialog/profile_info_grid.dart';
import 'package:admin_dashboard_graduation_project/features/doctor_verification/presentation/widgets/details_dialog/status_alerts_section.dart';
import 'package:flutter/material.dart';
import '../../../domain/entities/doctor_verification_entity.dart';

class DoctorProfileSection extends StatelessWidget {
  final DoctorVerificationEntity doctor;
  const DoctorProfileSection({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileAvatar(name: doctor.doctorName),
            const SizedBox(width: 24),
            Expanded(child: ProfileInfoGrid(doctor: doctor)),
          ],
        ),
        StatusAlertsSection(doctor: doctor),
      ],
    );
  }
}
