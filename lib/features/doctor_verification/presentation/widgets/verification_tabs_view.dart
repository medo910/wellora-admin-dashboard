import 'package:flutter/material.dart';
import '../../domain/entities/doctor_verification_entity.dart';
import 'doctor_verification_card.dart';

class VerificationTabsView extends StatelessWidget {
  final List<DoctorVerificationEntity> verifications;
  const VerificationTabsView({super.key, required this.verifications});

  @override
  Widget build(BuildContext context) {
    // تصفية البيانات (Logic)
    final pending = verifications
        .where(
          (v) =>
              v.documents.any((d) => d.status == "Pending") &&
              v.documents.every((d) => d.status != "Rejected"),
        )
        .toList();

    final approved = verifications
        .where((v) => v.documents.every((d) => d.status == "Approved"))
        .toList();

    final rejected = verifications
        .where((v) => v.documents.any((d) => d.status == "Rejected"))
        .toList();

    return DefaultTabController(
      length: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            indicatorColor: Colors.teal,
            labelColor: Colors.teal,
            unselectedLabelColor: Colors.grey,
            tabs: [
              const Tab(text: "All"),
              Tab(text: "Pending (${pending.length})"),
              Tab(text: "Approved (${approved.length})"),
              Tab(text: "Rejected (${rejected.length})"),
            ],
          ),
          const SizedBox(height: 24),

          // المايسترو اللي بيغير الـ Grid بناءً على التاب
          Builder(
            builder: (context) {
              final controller = DefaultTabController.of(context);
              return AnimatedBuilder(
                animation: controller,
                builder: (context, _) {
                  switch (controller.index) {
                    case 0:
                      return _buildGrid(verifications, "No applications");
                    case 1:
                      return _buildGrid(pending, "No pending");
                    case 2:
                      return _buildGrid(approved, "No approved");
                    case 3:
                      return _buildGrid(rejected, "No rejected");
                    default:
                      return const SizedBox();
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGrid(List<DoctorVerificationEntity> list, String emptyMsg) {
    if (list.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(60.0),
          child: Text(emptyMsg, style: const TextStyle(color: Colors.grey)),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true, // ضروري عشان جوه ScrollView
      physics:
          const NeverScrollableScrollPhysics(), // بنمنع الـ Grid يسكرول لوحده
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        mainAxisExtent:
            420, // ده اللي بيتحكم في "لم" الكارت ويشيل المساحة الفاضية
      ),
      itemCount: list.length,
      itemBuilder: (context, index) =>
          DoctorVerificationCard(doctor: list[index]),
    );
  }
}
