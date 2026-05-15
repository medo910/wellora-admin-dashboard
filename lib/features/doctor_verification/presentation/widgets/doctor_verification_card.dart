import 'package:flutter/material.dart';
import '../../domain/entities/doctor_verification_entity.dart';
import 'card_components/card_header.dart';
import 'card_components/card_info_grid.dart';
import 'card_components/card_footer_actions.dart';

class DoctorVerificationCard extends StatelessWidget {
  final DoctorVerificationEntity doctor;
  const DoctorVerificationCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CardHeader(doctor: doctor),

            const SizedBox(height: 16),

            CardInfoGrid(doctor: doctor),

            const SizedBox(height: 16),

            const Text(
              "Documents:",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            _buildDocsTags(),

            const SizedBox(height: 24),

            CardFooterActions(doctor: doctor),
          ],
        ),
      ),
    );
  }

  Widget _buildDocsTags() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: doctor.documents
          .map(
            (doc) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade100),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.file_copy_outlined,
                    size: 14,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    doc.documentType,
                    style: const TextStyle(fontSize: 12, color: Colors.black87),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
