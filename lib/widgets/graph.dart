import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Graph extends StatelessWidget {
  // pH Air, Kadar PPM, Suhu Air
  final String title;

  // pH, PPM, Suhu (\u00B0C)
  final String page;

  // DatabaseReference
  final Future<DatabaseEvent> ref;

  const Graph({
    super.key,
    required this.page,
    required this.title,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return FutureBuilder(
      future: ref,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          var data = snapshot.data!.snapshot.value;

          List<FlSpot> spots = [
            const FlSpot(1, 1),
          ];

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              Text(
                '$data \u00B0C',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
              ),
              const Divider(),
              //     Padding(
              //       padding: const EdgeInsets.all(16.0),
              //       child: AspectRatio(
              //         aspectRatio: 5,
              //         child: LineChart(
              //           LineChartData(
              //             lineBarsData: [
              //               LineChartBarData(
              //                 spots: spots,
              //                 color: theme.primaryColor,
              //                 isCurved: false,
              //                 dotData: const FlDotData(show: false),
              //               ),
              //             ],
              //             titlesData: FlTitlesData(
              //               topTitles: const AxisTitles(
              //                 sideTitles: SideTitles(showTitles: false),
              //               ),
              //               rightTitles: const AxisTitles(
              //                 sideTitles:
              //                     SideTitles(showTitles: false, reservedSize: 30),
              //               ),
              //               leftTitles: AxisTitles(
              //                 axisNameWidget: Text(page),
              //                 sideTitles: const SideTitles(
              //                   showTitles: true,
              //                   reservedSize: 30,
              //                 ),
              //               ),
              //               bottomTitles: const AxisTitles(
              //                 axisNameWidget: Text('Jam'),
              //                 sideTitles: SideTitles(
              //                   showTitles: true,
              //                   interval: 1,
              //                   reservedSize: 30,
              //                 ),
              //               ),
              //             ),
              //             minY: 0,
              //           ),
              //         ),
              //       ),
              //     ),
            ],
          );
        }

        return const Center(child: Text('Error'));
      },
    );
  }
}
