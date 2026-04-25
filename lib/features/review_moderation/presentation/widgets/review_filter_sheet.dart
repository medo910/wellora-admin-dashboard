// presentation/widgets/review_filter_sheet.dart

import 'package:admin_dashboard_graduation_project/features/review_moderation/presentation/manager/review_moderation_cubit/review_moderation_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReviewFilterSheet extends StatefulWidget {
  final double? initialMinR;
  final double? initialMaxR;
  final DateTimeRange? initialDateRange;
  final int? initialDoctorId; // 🚀 أضفنا دول للـ Constructor
  final int? initialUserId;

  const ReviewFilterSheet({
    super.key,
    this.initialMinR,
    this.initialMaxR,
    this.initialDateRange,
    this.initialDoctorId,
    this.initialUserId,
  });

  @override
  State<ReviewFilterSheet> createState() => _ReviewFilterSheetState();
}

class _ReviewFilterSheetState extends State<ReviewFilterSheet> {
  late RangeValues _ratingValues;
  DateTimeRange? _selectedDateRange;
  // 🚀 إضافة Controllers للـ IDs
  // final _docIdController = TextEditingController();
  // final _userIdController = TextEditingController();
  late TextEditingController _docIdController;
  late TextEditingController _userIdController;
  @override
  void initState() {
    super.initState();
    _ratingValues = RangeValues(
      widget.initialMinR ?? 1.0,
      widget.initialMaxR ?? 5.0,
    );
    _selectedDateRange = widget.initialDateRange;
    // 🚀 تهيئة الـ TextFields بقيم الـ IDs إذا كانت موجود  ة
    // _docIdController.text = widget.initialDoctorId?.toString() ?? '';
    // _userIdController.text = widget.initialUserId?.toString() ?? '';
    _docIdController = TextEditingController(
      text: widget.initialDoctorId?.toString() ?? "",
    );
    _userIdController = TextEditingController(
      text: widget.initialUserId?.toString() ?? "",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        left: 24,
        right: 24,
        top: 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Filter Reviews",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(child: _buildIdField("Doctor ID", _docIdController)),
                const SizedBox(width: 12),
                Expanded(child: _buildIdField("User ID", _userIdController)),
              ],
            ),

            const SizedBox(height: 20),

            // ⭐️ Rating Range
            Text(
              "Rating Range: ${_ratingValues.start.toStringAsFixed(1)} - ${_ratingValues.end.toStringAsFixed(1)}",
            ),
            RangeSlider(
              values: _ratingValues,
              min: 1.0,
              max: 5.0,
              divisions: 8,
              activeColor: Colors.teal,
              labels: RangeLabels(
                _ratingValues.start.toString(),
                _ratingValues.end.toString(),
              ),
              onChanged: (values) => setState(() => _ratingValues = values),
            ),

            const SizedBox(height: 16),

            // 📅 Date Range
            ListTile(
              leading: const Icon(Icons.calendar_today, color: Colors.teal),
              title: Text(
                _selectedDateRange == null
                    ? "Select Date Range"
                    : "From: ${_selectedDateRange!.start.toString().substring(0, 10)}",
              ),
              subtitle: _selectedDateRange == null
                  ? null
                  : Text(
                      "To: ${_selectedDateRange!.end.toString().substring(0, 10)}",
                    ),
              onTap: _pickDateRange,
            ),

            const SizedBox(height: 32),

            // 🚀 Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      context.read<ReviewModerationCubit>().resetFilters();
                      Navigator.pop(context); // 🚀 قفل الدايلوج بعد الـ Reset
                    },
                    child: const Text("Reset All"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                    ),
                    onPressed: _applyFilters,
                    child: const Text(
                      "Apply Filters",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _selectedDateRange = picked);
  }

  Widget _buildIdField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        isDense: true,
      ),
    );
  }

  void _applyFilters() {
    context.read<ReviewModerationCubit>().fetchReviews(
      minRating: _ratingValues.start,
      maxRating: _ratingValues.end,
      fromDate: _selectedDateRange?.start.toIso8601String(),
      toDate: _selectedDateRange?.end.toIso8601String(),
      doctorId: _docIdController.text.isNotEmpty
          ? int.tryParse(_docIdController.text)
          : null,
      userId: _userIdController.text.isNotEmpty
          ? int.tryParse(_userIdController.text)
          : null,
    );
    Navigator.pop(context);
  }
}
