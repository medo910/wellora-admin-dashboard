// lib/features/dashboard/presentation/widgets/registration_trends_chart.dart
import 'package:admin_dashboard_graduation_project/features/dashboard/domain/entities/user_stats_entity.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class RegistrationTrendsChart extends StatelessWidget {
  final UserStatsEntity userStats; // استقبال إحصائيات المستخدمين

  const RegistrationTrendsChart({super.key, required this.userStats});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade100),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "User Registration Trends",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 300,
              child: LineChart(
                LineChartData(
                  // نظبط الـ Y-axis ليكون أعلى من إجمالي الدكاترة بشوية
                  minY: 0,
                  maxY: 30,
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) =>
                        FlLine(color: Colors.grey.shade100, strokeWidth: 1),
                  ),
                  titlesData: _buildTitlesData(),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    // خط المرضى (Patients) - الإجمالي 6
                    _buildLineBarData(
                      spots: [
                        const FlSpot(0, 1),
                        const FlSpot(2, 3),
                        const FlSpot(4, 2),
                        FlSpot(
                          6,
                          userStats.totalPatients.toDouble(),
                        ), // القيمة الحقيقية
                      ],
                      color: const Color(0xFF008080),
                    ),
                    // خط الدكاترة (Doctors) - الإجمالي 21
                    _buildLineBarData(
                      spots: [
                        const FlSpot(0, 5),
                        const FlSpot(2, 12),
                        const FlSpot(4, 15),
                        FlSpot(
                          6,
                          userStats.totalDoctors.toDouble(),
                        ), // القيمة الحقيقية
                      ],
                      color: const Color(0xFF10B981),
                    ),
                  ],
                ),
              ),
            ),
            // Legend (مفتاح الرسم البياني)
            const SizedBox(height: 16),
            _buildLegend(),
          ],
        ),
      ),
    );
  }

  // ميثود لبناء مفتاح الرسم البياني عشان نعرف مين مريض ومين دكتور
  Widget _buildLegend() {
    return Row(
      children: [
        _legendItem("Patients", const Color(0xFF008080)),
        const SizedBox(width: 16),
        _legendItem("Doctors", const Color(0xFF10B981)),
      ],
    );
  }

  Widget _legendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  LineChartBarData _buildLineBarData({
    required List<FlSpot> spots,
    required Color color,
  }) {
    return LineChartBarData(
      spots: spots,
      isCurved: true,
      color: color,
      barWidth: 3,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.withValues(alpha: 0.2), color.withValues(alpha: 0)],
        ),
      ),
    );
  }

  FlTitlesData _buildTitlesData() {
    return FlTitlesData(
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul'];
            if (value.toInt() < months.length) {
              return Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  months[value.toInt()],
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
