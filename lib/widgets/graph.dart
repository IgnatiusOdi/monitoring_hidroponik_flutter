import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../model/data.dart';
import '../model/graph_data.dart';

class Graph extends StatelessWidget {
  // pH Air, Kadar PPM, Suhu Air
  final String title;

  // pH, PPM, Suhu (\u00B0C)
  final String page;

  // DatabaseReference
  final DatabaseReference ref;

  const Graph({
    super.key,
    required this.page,
    required this.title,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: ref.onValue,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        var data = Data.fromJson(
            snapshot.data!.snapshot.value as Map<dynamic, dynamic>);

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
            ),
            Text(
              page == 'pH'
                  ? '${data.ph}'
                  : page == 'PPM'
                      ? '${data.ppm}'
                      : '${data.suhu} \u00B0C',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: AspectRatio(
                  aspectRatio: 5,
                  child: SfCartesianChart(
                    primaryXAxis: const DateTimeAxis(),
                    title: ChartTitle(text: 'Grafik $page'),
                    series: <LineSeries<GraphData, dynamic>>[
                      LineSeries(
                        dataSource: data.data,
                        xValueMapper: (GraphData data, _) => data.tanggal,
                        yValueMapper: (GraphData data, _) => page == 'pH'
                            ? double.parse(data.value!.split(',')[0])
                            : page == 'PPM'
                                ? double.parse(data.value!.split(',')[1])
                                : double.parse(data.value!.split(',')[2]),
                        dataLabelSettings:
                            const DataLabelSettings(isVisible: true),
                      ),
                    ],
                  )),
            ),
          ],
        );
      },
    );
  }
}
