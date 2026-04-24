import 'package:admin_dashboard_graduation_project/features/doctor_verification/domain/entities/doctor_verification_entity.dart';
import 'package:flutter/material.dart';

class CardInfoGrid extends StatelessWidget {
  final DoctorVerificationEntity doctor;
  const CardInfoGrid({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      children: [
        _infoItem(Icons.email_outlined, doctor.doctorEmail),
        _infoItem(
          Icons.location_on_outlined,
          doctor.clinicLocation ?? "No Location",
        ),
        _infoItem(Icons.work_outline, "${doctor.yearsOfExperience} years exp."),
        _infoItem(
          Icons.calendar_today_outlined,
          _formatDate(doctor.submittedAt),
        ),
      ],
    );
  }

  Widget _infoItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade500),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _formatDate(String dateStr) {
    try {
      DateTime dt = DateTime.parse(dateStr);
      List<String> months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return "${months[dt.month - 1]} ${dt.day}";
    } catch (_) {
      return dateStr;
    }
  }
}
