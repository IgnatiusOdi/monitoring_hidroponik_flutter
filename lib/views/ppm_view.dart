import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PpmView extends StatelessWidget {
  const PpmView({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Kadar PPM',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
            const Text('560',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32)),
            const Text('Nutrisi terakhir ditambahkan 3 hari yang lalu',
                style: TextStyle(fontSize: 20)),
            AspectRatio(
              aspectRatio: 4,
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                        spots: [
                          const FlSpot(0, 560),
                          const FlSpot(1, 560),
                          const FlSpot(2, 560),
                          const FlSpot(3, 560),
                          const FlSpot(4, 560),
                          const FlSpot(5, 560),
                          const FlSpot(6, 560),
                          const FlSpot(7, 560),
                          const FlSpot(8, 560),
                          const FlSpot(9, 560),
                          const FlSpot(10, 560),
                          const FlSpot(11, 560),
                          const FlSpot(12, 560),
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
