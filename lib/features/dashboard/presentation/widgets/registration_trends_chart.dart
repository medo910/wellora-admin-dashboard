// lib/features/dashboard/presentation/widgets/registration_trends_chart.dart
import 'package:admin_dashboard_graduation_project/features/dashboard/domain/entities/user_registration_trend_entity.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class RegistrationTrendsChart extends StatelessWidget {
  final List<UserRegistrationTrendEntity> trends;
  const RegistrationTrendsChart({super.key, required this.trends});

  @override
  Widget build(BuildContext context) {
    List<FlSpot> doctorSpots = trends.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.doctors.toDouble());
    }).toList();

    List<FlSpot> patientSpots = trends.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.patients.toDouble());
    }).toList();
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
                  minY: 0,
                  maxY: 60,
                  gridData: FlGridData(show: true, drawVerticalLine: false),
                  titlesData: _buildTitlesData(trends),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    _buildLineBarData(
                      spots: patientSpots,
                      color: const Color(0xFF008080),
                    ),
                    _buildLineBarData(
                      spots: doctorSpots,
                      color: const Color(0xFF10B981),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildLegend(),
          ],
        ),
      ),
    );
  }

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

  FlTitlesData _buildTitlesData(List<UserRegistrationTrendEntity> trends) {
    return FlTitlesData(
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: 1,
          reservedSize: 30,
          getTitlesWidget: (value, meta) {
            int index = value.toInt();

            if (value == index.toDouble() &&
                index >= 0 &&
                index < trends.length) {
              return Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  trends[index].month.split(' ')[0],
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
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
