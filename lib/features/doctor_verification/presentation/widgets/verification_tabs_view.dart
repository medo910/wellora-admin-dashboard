import 'package:admin_dashboard_graduation_project/features/dashboard/domain/entities/verification_stats_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/doctor_verification_entity.dart';
import 'doctor_verification_card.dart';

// lib/features/doctor_verification/presentation/widgets/verification_tabs_view.dart

// class VerificationTabsView extends StatelessWidget {
//   final List<DoctorVerificationEntity> verifications;
//   const VerificationTabsView({super.key, required this.verifications});

//   @override
//   Widget build(BuildContext context) {
//     // 💡 الفلترة بقت "مباشرة" وسهلة جداً دلوقتي
//     // بنعتبر الـ Incomplete والـ Pending في تاب واحدة لأنهم "تحت المراجعة"
//     final pending = verifications
//         .where(
//           (v) =>
//               v.overallStatus == "Pending" || v.overallStatus == "Incomplete",
//         )
//         .toList();

//     final approved = verifications
//         .where((v) => v.overallStatus == "Approved")
//         .toList();

//     final rejected = verifications
//         .where((v) => v.overallStatus == "Rejected")
//         .toList();

//     return DefaultTabController(
//       length: 4,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           TabBar(
//             isScrollable: true,
//             tabAlignment: TabAlignment.start,
//             indicatorColor: Colors.teal,
//             labelColor: Colors.teal,
//             unselectedLabelColor: Colors.grey,
//             tabs: [
//               const Tab(text: "All"),
//               Tab(text: "Pending (${pending.length})"),
//               Tab(text: "Approved (${approved.length})"),
//               Tab(text: "Rejected (${rejected.length})"),
//             ],
//           ),
//           const SizedBox(height: 24),

//           Builder(
//             builder: (context) {
//               final controller = DefaultTabController.of(context);
//               return AnimatedBuilder(
//                 animation: controller,
//                 builder: (context, _) {
//                   switch (controller.index) {
//                     case 0:
//                       return _buildGrid(verifications, "No applications found");
//                     case 1:
//                       return _buildGrid(pending, "No pending applications");
//                     case 2:
//                       return _buildGrid(approved, "No approved applications");
//                     case 3:
//                       return _buildGrid(rejected, "No rejected applications");
//                     default:
//                       return const SizedBox();
//                   }
//                 },
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildGrid(List<DoctorVerificationEntity> list, String emptyMsg) {
//     if (list.isEmpty) {
//       return Center(
//         child: Padding(
//           padding: const EdgeInsets.all(60.0),
//           child: Text(emptyMsg, style: const TextStyle(color: Colors.grey)),
//         ),
//       );
//     }

//     return GridView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 3,
//         crossAxisSpacing: 20,
//         mainAxisSpacing: 20,
//         mainAxisExtent: 420, // بيحافظ على شكل الكارت ثابت وملموم
//       ),
//       itemCount: list.length,
//       itemBuilder: (context, index) =>
//           DoctorVerificationCard(doctor: list[index]),
//     );
//   }
// }

import '../manager/doctor_verification_cubit/doctor_verification_cubit.dart';

// class VerificationTabsView extends StatefulWidget {
//   final List<DoctorVerificationEntity> verifications;
//   const VerificationTabsView({super.key, required this.verifications});

//   @override
//   State<VerificationTabsView> createState() => _VerificationTabsViewState();
// }

// class _VerificationTabsViewState extends State<VerificationTabsView>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;

//   // خارطة لتحويل رقم التابة لكلمة يفهمها السيرفر
//   final List<String?> statusMapping = [null, "Pending", "Approved", "Rejected"];

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 4, vsync: this);

//     // 💡 أهم جزء: لما الأدمن يغير التابة، بنطلب داتا جديدة من السيرفر
//     _tabController.addListener(() {
//       if (_tabController.indexIsChanging) {
//         context.read<DoctorVerificationCubit>().fetchVerificationData(
//           page: 1, // ارجع لصفحة 1 دايماً مع تغيير التابة
//           status: statusMapping[_tabController.index],
//         );
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         TabBar(
//           controller: _tabController,
//           isScrollable: true,
//           tabAlignment: TabAlignment.start,
//           indicatorColor: Colors.teal,
//           labelColor: Colors.teal,
//           unselectedLabelColor: Colors.grey,
//           tabs: const [
//             Tab(text: "All"),
//             Tab(text: "Pending"),
//             Tab(text: "Approved"),
//             Tab(text: "Rejected"),
//           ],
//         ),
//         const SizedBox(height: 24),

//         // 💡 مبقاش فيه Switch ولا AnimatedBuilder
//         // بنعرض الداتا اللي الكيوبت جابها فوراً لأنها "متفلترة" جاهزة من السيرفر
//         _buildGrid(widget.verifications, "No doctors found in this category"),
//       ],
//     );
//   }

//   Widget _buildGrid(List<DoctorVerificationEntity> list, String emptyMsg) {
//     if (list.isEmpty) {
//       return Center(
//         child: Padding(
//           padding: const EdgeInsets.all(60.0),
//           child: Text(emptyMsg, style: const TextStyle(color: Colors.grey)),
//         ),
//       );
//     }

//     return GridView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 3,
//         crossAxisSpacing: 20,
//         mainAxisSpacing: 20,
//         mainAxisExtent: 420,
//       ),
//       itemCount: list.length,
//       itemBuilder: (context, index) =>
//           DoctorVerificationCard(doctor: list[index]),
//     );
//   }
// }

class VerificationTabsView extends StatefulWidget {
  final List<DoctorVerificationEntity> verifications;
  final String? currentStatus; // 💡 استقبل الحالة الحالية هنا
  // final VerificationStatsEntity stats; // 💡 ضيف الـ stats هنا

  const VerificationTabsView({
    super.key,
    required this.verifications,
    this.currentStatus, // 💡 استقبله هنا
    // required this.stats, // 💡 استقبله هنا
  });

  @override
  State<VerificationTabsView> createState() => _VerificationTabsViewState();
}

class _VerificationTabsViewState extends State<VerificationTabsView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // خارطة لتحويل رقم التابة لكلمة يفهمها السيرفر
  // 💡 لاحظ: خلينا التانية "Pending" والباك إند المفروض يجمع معاها الـ Incomplete
  final List<String?> statusMapping = [
    "All",
    "Pending",
    "Approved",
    "Rejected",
  ];

  // @override
  // void initState() {
  //   super.initState();
  //   int initialIndex = statusMapping.indexOf(widget.currentStatus);
  //   if (initialIndex == -1) initialIndex = 0;
  //   _tabController = TabController(
  //     length: 4,
  //     vsync: this,
  //     initialIndex: initialIndex,
  //   );
  //   setState(() {});
  //   _tabController.addListener(() {
  //     if (_tabController.indexIsChanging) {
  //       context.read<DoctorVerificationCubit>().fetchVerificationData(
  //         page: 1,
  //         status: statusMapping[_tabController.index],
  //       );
  //     }
  //   });
  // }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    // نحدد الـ index بناءً على الحالة الحالية
    if (widget.currentStatus != null) {
      int idx = statusMapping.indexOf(widget.currentStatus!);
      if (idx != -1) _tabController.index = idx;
    }

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        context.read<DoctorVerificationCubit>().fetchVerificationData(
          page: 1,
          status: statusMapping[_tabController.index], // هيبعت "All" أو الحالة
        );
      }
    });
  }

  @override
  void didUpdateWidget(VerificationTabsView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 💡 لو الحالة اللي جاية من الكيوبت اتغيرت، حرك الكنترولر للمكان الصح
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
          // 💡 هنا رجعنا الأرقام بس من الـ stats اللي جاية من السيرفر (أدق وأسرع)
          tabs: [
            const Tab(text: "All"),
            Tab(text: "Pending "), // جمعناهم سوا
            Tab(text: "Approved "),
            Tab(text: "Rejected "),
          ],
        ),
        const SizedBox(height: 24),

        // بنعرض الداتا اللي في الـ State حالياً (المتفلترة سيرفر)
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
