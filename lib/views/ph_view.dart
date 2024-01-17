import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PhView extends StatelessWidget {
  const PhView({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('pH Air',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
            const Text('6,0',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32)),
            AspectRatio(
              aspectRatio: 4,
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                        spots: [
                          const FlSpot(0, 6.0),
                          const FlSpot(1, 6.0),
                          const FlSpot(2, 6.0),
                          const FlSpot(3, 6.0),
                          const FlSpot(4, 6.0),
                          const FlSpot(5, 6.0),
                          const FlSpot(6, 6.0),
                          const FlSpot(7, 6.0),
                          const FlSpot(8, 6.0),
                          const FlSpot(9, 6.0),
                          const FlSpot(10, 6.0),
                          const FlSpot(11, 6.0),
                          const FlSpot(12, 6.0),
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
                      axisNameWidget: Text('Suhu (C)'),
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
