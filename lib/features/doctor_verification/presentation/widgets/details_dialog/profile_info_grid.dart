import 'package:admin_dashboard_graduation_project/features/doctor_verification/domain/entities/doctor_verification_entity.dart';
import 'package:flutter/material.dart';

class ProfileInfoGrid extends StatelessWidget {
  final DoctorVerificationEntity doctor;
  const ProfileInfoGrid({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildColumn("CONTACT", [
          _infoRow(Icons.email_outlined, doctor.doctorEmail),
          _infoRow(Icons.phone_outlined, doctor.phoneNumber ?? "N/A"),
          _infoRow(
            Icons.location_on_outlined,
            doctor.clinicLocation ?? "No Location",
          ),
        ]),
        const SizedBox(width: 40),
        _buildColumn("PROFESSIONAL", [
          _infoRow(Icons.business_outlined, doctor.specialization),
          _infoRow(
            Icons.work_outline,
            "${doctor.yearsOfExperience} years exp.",
          ),
          _infoRow(
            Icons.calendar_today_outlined,
            "Applied ${doctor.submittedAt.toString().substring(0, 10)} ",
          ),
          _infoRow(
            Icons.access_time,
            "time at ${doctor.submittedAt.toString().substring(11, 16)}",
          ),
        ], showBadge: doctor.overallStatus == "Approved"),
      ],
    );
  }

  Widget _buildColumn(
    String title,
    List<Widget> items, {
    bool showBadge = false,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ),
              if (showBadge) _ApprovedBadge(),
            ],
          ),
          const SizedBox(height: 16),
          ...items,
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade400),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, color: Color(0xFF334155)),
            ),
          ),
        ],
      ),
    );
  }
}

class _ApprovedBadge extends StatelessWidget {
  const _ApprovedBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFDCFCE7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, color: Color(0xFF166534), size: 12),
          SizedBox(width: 4),
          Text(
            "Approved",
            style: TextStyle(
              color: Color(0xFF166534),
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
