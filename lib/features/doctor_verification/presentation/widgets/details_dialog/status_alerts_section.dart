import 'package:admin_dashboard_graduation_project/features/doctor_verification/domain/entities/doctor_verification_entity.dart';
import 'package:flutter/material.dart';

class StatusAlertsSection extends StatelessWidget {
  final DoctorVerificationEntity doctor;
  const StatusAlertsSection({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (doctor.overallStatus == "Incomplete") _buildMissingDocsBanner(),
        if (doctor.overallStatus == "Rejected") ...[
          _buildAlert(
            title: "Rejection Reason",
            note: doctor.rejectionReason ?? "No reason specified",
            color: Colors.red,
          ),
          if (doctor.adminNotes != null)
            _buildAlert(
              title: "Admin Notes",
              note: doctor.adminNotes!,
              color: Colors.redAccent,
            ),
        ],
        if (doctor.overallStatus == "Approved" && doctor.adminNotes != null)
          _buildAlert(
            title: "Admin Notes",
            note: doctor.adminNotes!,
            color: Colors.green,
          ),
        if (doctor.reviewedByAdminName != null)
          _buildAlert(
            title: "Reviewed By",
            note: "${doctor.reviewedByAdminName} (Admin)",
            color: Colors.blueGrey,
          ),
      ],
    );
  }

  Widget _buildMissingDocsBanner() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Colors.orange,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "Missing: ${doctor.missingRequiredDocuments.join(', ')}",
              style: const TextStyle(color: Colors.orange, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlert({
    required String title,
    required String note,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Text(
            "$title: ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: 13,
            ),
          ),
          Text(note, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }
}
