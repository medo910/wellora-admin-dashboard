// import 'package:flutter/material.dart';
// import '../../../domain/entities/verification_document_entity.dart';

// class DocumentsListSection extends StatelessWidget {
//   final List<VerificationDocumentEntity> documents;
//   const DocumentsListSection({super.key, required this.documents});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           "DOCUMENTS",
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 12,
//             color: Colors.grey,
//             letterSpacing: 1.1,
//           ),
//         ),
//         const SizedBox(height: 16),
//         ...documents.map((doc) => _DocumentTile(doc: doc)),
//       ],
//     );
//   }
// }

// class _DocumentTile extends StatelessWidget {
//   final VerificationDocumentEntity doc;
//   const _DocumentTile({required this.doc});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF8FAFC),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: const Color(0xFFE2E8F0)),
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               color: const Color(0xFFDCFCE7),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: const Icon(
//               Icons.file_copy_outlined,
//               color: Color(0xFF166534),
//               size: 20,
//             ),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   doc.documentType,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 15,
//                   ),
//                 ),
//                 const Text(
//                   "Uploaded 3/14/2026",
//                   style: TextStyle(fontSize: 12, color: Colors.grey),
//                 ),
//               ],
//             ),
//           ),
//           IconButton(
//             onPressed: () {},
//             icon: const Icon(Icons.open_in_new, size: 20, color: Colors.grey),
//           ),
//         ],
//       ),
//     );
//   }
// }

// lib/features/doctor_verification/presentation/widgets/details_dialog/documents_list_section.dart

import 'package:admin_dashboard_graduation_project/features/doctor_verification/domain/entities/verification_document_entity.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';

class DocumentsListSection extends StatelessWidget {
  final List<VerificationDocumentEntity> documents;
  const DocumentsListSection({super.key, required this.documents});

  @override
  Widget build(BuildContext context) {
    // تجهيز قائمة الصور للجاليري
    final List<ImageProvider> imageProviders = documents
        .map((doc) => CachedNetworkImageProvider(doc.fileUrl))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "DOCUMENTS",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
            color: Colors.grey,
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(height: 16),
        ...documents.asMap().entries.map((entry) {
          int index = entry.key;
          var doc = entry.value;
          return _buildDocumentTile(context, doc, index, imageProviders);
        }),
      ],
    );
  }

  Widget _buildDocumentTile(
    BuildContext context,
    VerificationDocumentEntity doc,
    int index,
    List<ImageProvider> allImages,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          // 🖼️ Thumbnail المعاينة
          GestureDetector(
            onTap: () {
              // 🚀 فتح الجاليري عند الضغط على الصورة
              showImageViewerPager(
                context,
                MultiImageProvider(allImages, initialIndex: index),
                swipeDismissible: true,
                doubleTapZoomable: true,
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: doc.fileUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.image),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.red.shade50,
                  child: const Icon(Icons.error_outline, color: Colors.red),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // بيانات الملف
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doc.documentType,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const Text(
                  "Click image to preview",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.teal,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          // زرار تكبير (اختياري)
          IconButton(
            onPressed: () => showImageViewer(
              context,
              CachedNetworkImageProvider(doc.fileUrl),
            ),
            icon: const Icon(Icons.zoom_in, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
