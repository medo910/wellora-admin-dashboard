import 'package:admin_dashboard_graduation_project/features/doctor_verification/domain/entities/verification_document_entity.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';

class DocumentsListSection extends StatelessWidget {
  final List<VerificationDocumentEntity> documents;
  const DocumentsListSection({super.key, required this.documents});

  @override
  Widget build(BuildContext context) {
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
          GestureDetector(
            onTap: () {
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
