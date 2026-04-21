// // lib/features/doctor_verification/presentation/widgets/verification_details_dialog.dart

// import 'package:admin_dashboard_graduation_project/features/doctor_verification/domain/entities/doctor_verification_entity.dart';
// import 'package:admin_dashboard_graduation_project/features/doctor_verification/domain/entities/verification_document_entity.dart';
// import 'package:admin_dashboard_graduation_project/features/doctor_verification/presentation/manager/doctor_verification_cubit/doctor_verification_cubit.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// void showVerificationDetailsDialog(
//   BuildContext context,
//   DoctorVerificationEntity doctor,
// ) {
//   showDialog(
//     context: context,
//     builder: (dialogContext) => BlocProvider.value(
//       value: context.read<DoctorVerificationCubit>(),
//       child: Dialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         child: Container(
//           width: 700,
//           padding: const EdgeInsets.all(24),
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   "Application Details",
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 24),
//                 _DocumentViewerList(documents: doctor.documents),
//                 const SizedBox(height: 32),
//                 _ActionButtons(doctorId: doctor.doctorId),
//               ],
//             ),
//           ),
//         ),
//       ),
//     ),
//   );
// }

// class _ActionButtons extends StatelessWidget {
//   final int doctorId;
//   const _ActionButtons({required this.doctorId});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.end,
//       children: [
//         TextButton(
//           onPressed: () => Navigator.pop(context),
//           child: const Text("Close"),
//         ),
//         const SizedBox(width: 8),
//         ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.red.shade50,
//             foregroundColor: Colors.red,
//           ),
//           onPressed: () => showRejectPrompt(context, doctorId),
//           child: const Text("Reject"),
//         ),
//         const SizedBox(width: 8),
//         ElevatedButton(
//           style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
//           onPressed: () => context.read<DoctorVerificationCubit>().approveDoc(
//             doctorId,
//             "Documents verified",
//           ),
//           child: const Text("Approve Doctor"),
//         ),
//       ],
//     );
//   }
// }

// // يتم إضافته داخل ملف widgets/verification_details_dialog.dart أو كـ Helper

// void showRejectPrompt(BuildContext context, int doctorId) {
//   final TextEditingController reasonController = TextEditingController();
//   final TextEditingController notesController = TextEditingController();

//   showDialog(
//     context: context,
//     builder: (dialogContext) => AlertDialog(
//       title: const Row(
//         children: [
//           Icon(Icons.report_problem_outlined, color: Colors.red),
//           SizedBox(width: 8),
//           Text("Reject Application"),
//         ],
//       ),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           const Text(
//             "Please specify why you are rejecting this doctor's documents. The doctor will see this reason.",
//           ),
//           const SizedBox(height: 16),
//           TextField(
//             controller: reasonController,
//             maxLines: 3,
//             decoration: const InputDecoration(
//               labelText: "Rejection Reason (Required)",
//               hintText: "e.g., ID is expired or blurred...",
//               border: OutlineInputBorder(),
//             ),
//           ),
//           const SizedBox(height: 12),
//           TextField(
//             controller: notesController,
//             decoration: const InputDecoration(
//               labelText: "Admin Private Notes (Optional)",
//               border: OutlineInputBorder(),
//             ),
//           ),
//         ],
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(dialogContext),
//           child: const Text("Cancel"),
//         ),
//         ElevatedButton(
//           style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//           onPressed: () {
//             if (reasonController.text.trim().isEmpty) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text("Please provide a reason")),
//               );
//               return;
//             }
//             // بننادي الكيوبت بتاعنا
//             context.read<DoctorVerificationCubit>().rejectDoc(
//               doctorId,
//               reasonController.text,
//               notesController.text,
//             );
//             Navigator.pop(dialogContext); // قفل دايلوج الرفض
//             Navigator.pop(context); // قفل دايلوج التفاصيل الأساسي
//           },
//           child: const Text(
//             "Confirm Rejection",
//             style: TextStyle(color: Colors.white),
//           ),
//         ),
//       ],
//     ),
//   );
// }

// class _DocumentViewerList extends StatelessWidget {
//   final List<VerificationDocumentEntity> documents;
//   const _DocumentViewerList({required this.documents});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           "Documents",
//           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//         ),
//         const SizedBox(height: 16),
//         ...documents.map(
//           (doc) => Container(
//             margin: const EdgeInsets.only(bottom: 12),
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.grey.shade200),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Row(
//               children: [
//                 const Icon(Icons.description, color: Colors.teal),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         doc.documentType,
//                         style: const TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       Text(
//                         doc.status,
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: doc.status == "Approved"
//                               ? Colors.green
//                               : Colors.orange,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.open_in_new, size: 20),
//                   onPressed: () => _launchURL(
//                     doc.fileUrl,
//                   ), // محتاجة url_launcher أو تفتحها في WebView
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   void _launchURL(String url) {
//     // هنا ممكن تستخدم package: url_launcher
//     debugPrint("Opening URL: $url");
//   }
// }
