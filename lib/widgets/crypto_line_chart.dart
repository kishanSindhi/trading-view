import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../app_constants.dart';

class CryptoLineChart extends StatelessWidget {
  final List<FlSpot> spots;
  final double minY;
  final double maxY;
  final bool isPositive;

  const CryptoLineChart({
    super.key,
    required this.spots,
    required this.minY,
    required this.maxY,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    final lineColor = AppColors.primary;

    return LineChart(
      LineChartData(
        minY: minY,
        maxY: maxY,
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 22,
              interval: (spots.length / 4).floorToDouble().clamp(
                1,
                double.infinity,
              ),
              getTitlesWidget: (value, meta) {
                if (value == meta.min || value == meta.max) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    _label(value.toInt()),
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 10,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => AppColors.surface,
            tooltipBorder: const BorderSide(color: AppColors.border),
            getTooltipItems: (spots) => spots.map((s) {
              return LineTooltipItem(
                '\$${s.y.toStringAsFixed(2)}',
                TextStyle(
                  color: lineColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              );
            }).toList(),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            curveSmoothness: 0.5,
            color: lineColor,
            barWidth: 1.5,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
        ],
      ),
      duration: const Duration(milliseconds: 250),
    );
  }

  String _label(int index) {
    if (spots.isEmpty) return '';
    final hoursAgo = ((spots.length - index) * 15 / 60).round();
    if (hoursAgo == 0) return 'Now';
    return '${hoursAgo}h';
  }
}
