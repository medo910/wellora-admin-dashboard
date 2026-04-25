// features/review_moderation/presentation/widgets/review_card.dart

import 'package:admin_dashboard_graduation_project/features/review_moderation/domain/entities/review_entity.dart';
import 'package:admin_dashboard_graduation_project/features/review_moderation/presentation/widgets/review_card_components.dart';
import 'package:flutter/material.dart';

// class ReviewCard extends StatelessWidget {
//   final ReviewEntity review;
//   final VoidCallback? onDelete;
//   final VoidCallback? onRestore;

//   const ReviewCard({
//     super.key,
//     required this.review,
//     this.onDelete,
//     this.onRestore,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 16),
//       elevation: 0,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//         side: BorderSide(color: Colors.grey.shade200),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TargetInfo(doctorName: review.doctorName, date: review.reviewDate),
//             if (review.isDeleted) DeletedAuditInfo(review: review),
//             const SizedBox(height: 12),
//             Align(
//               alignment: Alignment.centerRight,
//               child: review.isDeleted
//                   ? ActionButton(
//                       label: "Restore",
//                       color: Colors.green,
//                       icon: Icons.restore,
//                       onPressed: onRestore,
//                     )
//                   : ActionButton(
//                       label: "Delete",
//                       color: Colors.red,
//                       icon: Icons.delete_outline,
//                       onPressed: onDelete,
//                     ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // Widgets صغيرة داخل الفايل للحفاظ على التنظيم
// class _UserInfo extends StatelessWidget {
//   final String name, email;
//   const _UserInfo({required this.name, required this.email});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           name,
//           style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
//         ),
//         Text(
//           email,
//           style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
//         ),
//       ],
//     );
//   }
// }

// class _RatingStars extends StatelessWidget {
//   final double rating;
//   const _RatingStars({required this.rating});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         const Icon(Icons.star, color: Colors.amber, size: 18),
//         const SizedBox(width: 4),
//         Text(
//           rating.toString(),
//           style: const TextStyle(fontWeight: FontWeight.bold),
//         ),
//       ],
//     );
//   }
// }

// تأكد من عمل import للـ ReviewEntity والـ ActionButton والـ TargetInfo

class ReviewCard extends StatelessWidget {
  final ReviewEntity review;
  final VoidCallback? onDelete;
  final VoidCallback? onRestore;

  const ReviewCard({
    super.key,
    required this.review,
    this.onDelete,
    this.onRestore,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1️⃣ الجزء العلوي: اسم المريض + التقييم (كان ناقص في الصورة)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _UserInfo(name: review.userName, email: review.userEmail),
                _RatingStars(rating: review.rating),
              ],
            ),

            const Divider(height: 24, thickness: 1),

            // 2️⃣ نص التعليق (الكومنت) - ده اللي بيملى الكارد
            Text(
              review.comment.isEmpty ? "No comment provided." : review.comment,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.5,
                fontStyle: FontStyle.italic,
              ),
            ),

            const SizedBox(height: 16),

            // 3️⃣ بيانات الدكتور والتاريخ (المكون اللي أنت مستخدمه فعلاً)
            TargetInfo(doctorName: review.doctorName, date: review.reviewDate),

            // 4️⃣ بيانات الحذف (تظهر فقط لو في تاب الـ Deleted)
            if (review.isDeleted) DeletedAuditInfo(review: review),

            const Divider(height: 24),

            // 5️⃣ زرار الأكشن (Delete أو Restore)
            Align(
              alignment: Alignment.centerRight,
              child: review.isDeleted
                  ? ActionButton(
                      label: "Restore",
                      color: Colors.green,
                      icon: Icons.restore,
                      onPressed: onRestore,
                    )
                  : ActionButton(
                      label: "Delete",
                      color: Colors.red,
                      icon: Icons.delete_outline,
                      onPressed: onDelete,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- المكونات الصغيرة المساعدة داخل نفس الفايل ---

class _UserInfo extends StatelessWidget {
  final String name, email;
  const _UserInfo({required this.name, required this.email});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        Text(
          email,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
        ),
      ],
    );
  }
}

class _RatingStars extends StatelessWidget {
  final double rating;
  const _RatingStars({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.star, color: Colors.amber, size: 16),
          const SizedBox(width: 4),
          Text(
            rating.toString(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }
}
