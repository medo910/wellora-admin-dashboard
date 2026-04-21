// lib/features/dashboard/presentation/widgets/stat_card.dart
import 'package:admin_dashboard_graduation_project/core/theme/app_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final double? change;
  final IconData icon;
  final Color chartColor;
  final Color iconColor;
  const StatCard({
    required this.title,
    required this.value,
    this.change,
    required this.icon,
    this.chartColor = AppColors.primary,
    this.iconColor = AppColors.primary,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // bool isPositive = change > 0;
    double displayChange = change ?? 0;
    bool isPositive = displayChange >= 0;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // خليه ياخد أقل مساحة ممكنة
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text(
          //       title,
          //       style: const TextStyle(
          //         color: AppColors.textMuted,
          //         fontSize: 14,
          //       ),
          //     ),
          //     Icon(icon, color: AppColors.textMuted, size: 20),
          //   ],
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 14,
                ),
              ),
              // الأيقونة بلونها الخاص
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          if (change != null)
            Row(
              children: [
                Icon(
                  isPositive ? Icons.trending_up : Icons.trending_down,
                  color: isPositive ? AppColors.success : AppColors.urgent,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  "${isPositive ? '+' : ''}$change%",
                  style: TextStyle(
                    color: isPositive ? AppColors.success : AppColors.urgent,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          const SizedBox(height: 16),
          // الـ Sparkline (الرسم البياني الصغير أسفل الكارت)
          SizedBox(
            height: 40,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      const FlSpot(0, 3),
                      const FlSpot(2, 4),
                      const FlSpot(4, 3.5),
                      const FlSpot(6, 5),
                      const FlSpot(8, 4.5),
                      const FlSpot(10, 6),
                    ],
                    isCurved: true,
                    color: chartColor,
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: chartColor.withValues(alpha: 0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
