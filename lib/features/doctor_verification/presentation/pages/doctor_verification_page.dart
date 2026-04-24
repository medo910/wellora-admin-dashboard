// // lib/features/doctor_verification/presentation/pages/doctor_verification_page.dart

// import 'package:admin_dashboard_graduation_project/features/doctor_verification/domain/entities/doctor_verification_entity.dart';
// import 'package:admin_dashboard_graduation_project/features/doctor_verification/presentation/manager/doctor_verification_cubit/doctor_verification_cubit.dart';
// import 'package:admin_dashboard_graduation_project/features/doctor_verification/presentation/widgets/doctor_verification_card.dart';
// import 'package:admin_dashboard_graduation_project/features/doctor_verification/presentation/widgets/verification_stats_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class DoctorVerificationPage extends StatefulWidget {
//   const DoctorVerificationPage({super.key});

//   @override
//   State<DoctorVerificationPage> createState() => _DoctorVerificationPageState();
// }

// class _DoctorVerificationPageState extends State<DoctorVerificationPage> {
//   @override
//   void initState() {
//     super.initState();
//     context.read<DoctorVerificationCubit>().fetchVerificationData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<DoctorVerificationCubit, DoctorVerificationState>(
//       listener: (context, state) {
//         if (state is VerificationActionSuccess)
//           _showSnackBar(context, state.message, Colors.green);
//         if (state is VerificationActionFailure)
//           _showSnackBar(context, state.errMessage, Colors.red);
//       },
//       builder: (context, state) {
//         return SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(32),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const VerificationHeader(),
//                 const SizedBox(height: 32),

//                 if (state is DoctorVerificationLoading)
//                   const Expanded(
//                     child: Center(child: CircularProgressIndicator()),
//                   )
//                 else if (state is DoctorVerificationSuccess)
//                   Expanded(
//                     child: Column(
//                       children: [
//                         VerificationStatsBar(stats: state.stats),
//                         const SizedBox(height: 24),
//                         // Expanded(
//                         //   child:
//                         VerificationTabsView(
//                           verifications: state.verifications,
//                         ),
//                         // ),
//                         const SizedBox(height: 32),
//                         const PaginationBar(),
//                       ],
//                     ),
//                   )
//                 else if (state is DoctorVerificationFailure)
//                   Center(child: Text(state.errMessage)),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   void _showSnackBar(BuildContext context, String msg, Color color) {
//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: color));
//   }
// }

// // lib/features/doctor_verification/presentation/pages/doctor_verification_page.dart

// class VerificationHeader extends StatelessWidget {
//   const VerificationHeader({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           "Doctor Verification",
//           style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           "Review and verify doctor applications and credentials.",
//           style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
//         ),
//       ],
//     );
//   }
// }

// class VerificationTabsView extends StatelessWidget {
//   final List<DoctorVerificationEntity> verifications;
//   const VerificationTabsView({super.key, required this.verifications});

//   @override
//   Widget build(BuildContext context) {
//     // تصفية البيانات للتابات
//     final pending = verifications
//         .where(
//           (v) =>
//               v.documents.any((d) => d.status == "Pending") &&
//               v.documents.every((d) => d.status != "Rejected"),
//         )
//         .toList();

//     final approved = verifications
//         .where((v) => v.documents.every((d) => d.status == "Approved"))
//         .toList();

//     final rejected = verifications
//         .where(
//           (v) => v.documents.any(
//             (d) => d.status == "Rejected",
//           ), // لو ورقة واحدة مرفوضة، الدكتور كله مرفوض
//         )
//         .toList();

//     return DefaultTabController(
//       length: 4,
//       child: Column(
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
//           Expanded(
//             child: TabBarView(
//               children: [
//                 _buildGrid(verifications, "No applications found"),
//                 _buildGrid(pending, "No pending applications"),
//                 _buildGrid(approved, "No approved applications"),
//                 _buildGrid(rejected, "No rejected applications"),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildGrid(List<DoctorVerificationEntity> list, String emptyMsg) {
//     if (list.isEmpty) return Center(child: Text(emptyMsg));
//     return GridView.builder(
//       shrinkWrap: true,
//       physics: NeverScrollableScrollPhysics(),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 3,
//         crossAxisSpacing: 20,
//         mainAxisSpacing: 20,
//         childAspectRatio: 0.85,
//       ),
//       itemCount: list.length,
//       itemBuilder: (context, index) =>
//           DoctorVerificationCard(doctor: list[index]),
//     );
//   }
// }

// class PaginationBar extends StatelessWidget {
//   const PaginationBar({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<DoctorVerificationCubit, DoctorVerificationState>(
//       builder: (context, state) {
//         if (state is! DoctorVerificationSuccess) return const SizedBox();

//         return Container(
//           padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(color: Colors.grey.shade200),
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 "Showing page ${state.page} of ${((state.stats.total) / 10).ceil()}",
//                 style: const TextStyle(color: Colors.grey),
//               ),
//               Row(
//                 children: [
//                   _pageButton(
//                     label: "Previous",
//                     icon: Icons.chevron_left,
//                     isEnabled: state.page > 1,
//                     onTap: () => context
//                         .read<DoctorVerificationCubit>()
//                         .fetchVerificationData(page: state.page - 1),
//                   ),
//                   const SizedBox(width: 12),
//                   _pageButton(
//                     label: "Next",
//                     icon: Icons.chevron_right,
//                     isEnabled: state.hasNextPage, // بنجيبها من الريسبونس
//                     onTap: () => context
//                         .read<DoctorVerificationCubit>()
//                         .fetchVerificationData(page: state.page + 1),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _pageButton({
//     required String label,
//     required IconData icon,
//     required bool isEnabled,
//     required VoidCallback onTap,
//   }) {
//     return OutlinedButton.icon(
//       onPressed: isEnabled ? onTap : null,
//       icon: Icon(icon, size: 18),
//       label: Text(label),
//       style: OutlinedButton.styleFrom(
//         foregroundColor: isEnabled ? Colors.teal : Colors.grey,
//         side: BorderSide(
//           color: isEnabled ? Colors.teal.shade200 : Colors.grey.shade200,
//         ),
//         disabledForegroundColor: Colors.grey.shade300,
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../manager/doctor_verification_cubit/doctor_verification_cubit.dart';
import '../widgets/verification_header.dart';
import '../widgets/verification_stats_bar.dart';
import '../widgets/verification_tabs_view.dart';
import '../widgets/pagination_bar.dart';

class DoctorVerificationPage extends StatefulWidget {
  const DoctorVerificationPage({super.key});

  @override
  State<DoctorVerificationPage> createState() => _DoctorVerificationPageState();
}

class _DoctorVerificationPageState extends State<DoctorVerificationPage> {
  @override
  void initState() {
    super.initState();
    context.read<DoctorVerificationCubit>().fetchVerificationData();
  }

  // @override
  // Widget build(BuildContext context) {
  //   return BlocConsumer<DoctorVerificationCubit, DoctorVerificationState>(
  //     listener: (context, state) {
  //       if (state is VerificationActionSuccess) {
  //         _showSnackBar(context, state.message, Colors.green);
  //       }
  //       if (state is VerificationActionFailure) {
  //         _showSnackBar(context, state.errMessage, Colors.red);
  //       }
  //     },
  //     builder: (context, state) {
  //       return Scaffold(
  //         backgroundColor: const Color(0xFFF8FAFC),
  //         // الصفحة كلها بتسكرول من هنا
  //         body: SingleChildScrollView(
  //           child: Padding(
  //             padding: const EdgeInsets.all(32),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 const VerificationHeader(),
  //                 const SizedBox(height: 32),

  //                 if (state is DoctorVerificationLoading)
  //                   const Center(
  //                     child: Padding(
  //                       padding: EdgeInsets.all(100.0),
  //                       child: CircularProgressIndicator(),
  //                     ),
  //                   )
  //                 else if (state is DoctorVerificationSuccess) ...[
  //                   // الـ Spread Operator (...) بيفرط الودجيتس جوه الـ Column الأساسي
  //                   VerificationStatsBar(stats: state.stats),
  //                   const SizedBox(height: 32),
  //                   VerificationTabsView(
  //                     verifications: state.verifications,
  //                     currentStatus: state.currentStatus,
  //                   ),
  //                   const SizedBox(height: 32),
  //                   const PaginationBar(),
  //                 ] else if (state is DoctorVerificationFailure)
  //                   Center(child: Text(state.errMessage)),
  //               ],
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DoctorVerificationCubit, DoctorVerificationState>(
      listener: (context, state) {
        if (state is VerificationActionSuccess)
          _showSnackBar(context, state.message, Colors.green);
        if (state is VerificationActionFailure)
          _showSnackBar(context, state.errMessage, Colors.red);
      },
      // builder: (context, state) {
      //   // 💡 السطر ده هو اللي هيحل لك أيرور الـ Undefined name
      //   final cubit = context.read<DoctorVerificationCubit>();

      //   return Scaffold(
      //     backgroundColor: const Color(0xFFF8FAFC),
      //     body: SingleChildScrollView(
      //       child: Padding(
      //         padding: const EdgeInsets.all(32),
      //         child: Column(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: [
      //             const VerificationHeader(),
      //             const SizedBox(height: 32),

      //             // 🚀 المنطق الذكي عشان التابات ماتختفيش واللون يفضل ثابت
      //             if (state is DoctorVerificationSuccess ||
      //                 state is VerificationActionLoading) ...[
      //               // الإحصائيات (دايماً ظاهرة لو فيه داتا)
      //               VerificationStatsBar(
      //                 stats: state is DoctorVerificationSuccess
      //                     ? state.stats
      //                     : cubit.stats!,
      //               ),
      //               const SizedBox(height: 32),

      //               // التابات (دايماً ظاهرة والـ currentStatus جاي من الكيوبت)
      //               VerificationTabsView(
      //                 verifications: state is DoctorVerificationSuccess
      //                     ? state.verifications
      //                     : [],
      //                 currentStatus: state is DoctorVerificationSuccess
      //                     ? state.currentStatus
      //                     : cubit.currentStatus,
      //               ),
      //               const SizedBox(height: 32),
      //               const PaginationBar(),
      //             ]
      //             // حالة التحميل (لو أول مرة خالص والصفحة لسه بيضاء)
      //             else if (state is DoctorVerificationLoading &&
      //                 cubit.currentPage == 1)
      //               const Center(
      //                 child: Padding(
      //                   padding: EdgeInsets.all(100.0),
      //                   child: CircularProgressIndicator(),
      //                 ),
      //               )
      //             // حالة الفشل
      //             else if (state is DoctorVerificationFailure)
      //               Center(child: Text(state.errMessage)),
      //           ],
      //         ),
      //       ),
      //     ),
      //   );
      // },
      builder: (context, state) {
        final cubit = context.read<DoctorVerificationCubit>();

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const VerificationHeader(),
                  const SizedBox(height: 32),

                  // 🚀 الشرط بقى أقوى: لو فيه داتا قديمة أو الحالة نجاح، اظهر التابات
                  if (state is DoctorVerificationSuccess ||
                      cubit.lastStats != null) ...[
                    // الإحصائيات (بتقرأ من الـ state أو من المخزن في الكيوبت)
                    VerificationStatsBar(
                      stats: state is DoctorVerificationSuccess
                          ? state.stats
                          : cubit.lastStats!,
                    ),
                    const SizedBox(height: 32),

                    // التابات (دايماً ظاهرة عشان اللون الأخضر ميهربش)
                    VerificationTabsView(
                      verifications: state is DoctorVerificationSuccess
                          ? state.verifications
                          : [],
                      currentStatus: state is DoctorVerificationSuccess
                          ? state.currentStatus
                          : cubit.currentStatus,
                    ),
                    const SizedBox(height: 32),
                    const PaginationBar(),
                  ]
                  // لو أول مرة في التاريخ ومفيش حتى stats قديمة
                  else if (state is DoctorVerificationLoading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(100.0),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else if (state is DoctorVerificationFailure)
                    Center(child: Text(state.errMessage)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showSnackBar(BuildContext context, String msg, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: color));
  }
}
