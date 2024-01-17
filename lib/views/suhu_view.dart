import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SuhuView extends StatelessWidget {
  const SuhuView({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Suhu Air',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
            const Text('25.1 \u00B0C',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32)),
            AspectRatio(
              aspectRatio: 4,
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                        spots: [
                          const FlSpot(0, 25.1),
                          const FlSpot(1, 25.2),
                          const FlSpot(2, 25.3),
                          const FlSpot(3, 25.4),
                          const FlSpot(4, 25.5),
                          const FlSpot(5, 25.6),
                          const FlSpot(6, 25.7),
                          const FlSpot(7, 25.8),
                          const FlSpot(8, 25.9),
                          const FlSpot(9, 26.0),
                          const FlSpot(10, 26.1),
                          const FlSpot(11, 26.2),
                          const FlSpot(12, 26.3),
                        ],
                        color: theme.primaryColor,
                        isCurved: false,
                        dotData: const FlDotData(show: false)),
                  ],
                  titlesData: const FlTitlesData(
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: AxisTitles(
                      axisNameWidget: Text('Suhu (\u00B0C)'),
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    bottomTitles: AxisTitles(
                      axisNameWidget: Text('Jam'),
                      sideTitles: SideTitles(showTitles: true),
                    ),
                  ),
                  minY: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
