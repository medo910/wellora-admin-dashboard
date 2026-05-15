import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/doctor_verification_entity.dart';
import 'doctor_verification_card.dart';

import '../manager/doctor_verification_cubit/doctor_verification_cubit.dart';

class VerificationTabsView extends StatefulWidget {
  final List<DoctorVerificationEntity> verifications;
  final String? currentStatus;

  const VerificationTabsView({
    super.key,
    required this.verifications,
    this.currentStatus,
  });

  @override
  State<VerificationTabsView> createState() => _VerificationTabsViewState();
}

class _VerificationTabsViewState extends State<VerificationTabsView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String?> statusMapping = [
    "All",
    "Pending",
    "Approved",
    "Rejected",
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    if (widget.currentStatus != null) {
      int idx = statusMapping.indexOf(widget.currentStatus!);
      if (idx != -1) _tabController.index = idx;
    }

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        context.read<DoctorVerificationCubit>().fetchVerificationData(
          page: 1,
          status: statusMapping[_tabController.index],
        );
      }
    });
  }

  @override
  void didUpdateWidget(VerificationTabsView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentStatus != oldWidget.currentStatus) {
      int newIndex = statusMapping.indexOf(widget.currentStatus);
      if (newIndex != -1 && newIndex != _tabController.index) {
        _tabController.animateTo(newIndex);
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          indicatorColor: Colors.teal,
          labelColor: Colors.teal,
          unselectedLabelColor: Colors.grey,
          tabs: [
            const Tab(text: "All"),
            Tab(text: "Pending "),
            Tab(text: "Approved "),
            Tab(text: "Rejected "),
          ],
        ),
        const SizedBox(height: 24),

        _buildGrid(widget.verifications, "No doctors found in this category"),
      ],
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
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        mainAxisExtent: 420,
      ),
      itemCount: list.length,
      itemBuilder: (context, index) =>
          DoctorVerificationCard(doctor: list[index]),
    );
  }
}
