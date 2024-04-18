import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../model/data.dart';
import '../model/graph_data.dart';

class Graph extends StatefulWidget {
  // pH Air, Kadar PPM, Suhu Air
  final String title;

  // ph, ppm, suhu (\u00B0C)
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
  State<Graph> createState() => _GraphState();
}

class _GraphState extends State<Graph> {
  late ZoomPanBehavior _zoomPanBehavior;
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _zoomPanBehavior = ZoomPanBehavior(
      enableMouseWheelZooming: true,
      enablePinching: true,
      zoomMode: ZoomMode.x,
      enablePanning: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.ref.onValue,
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
              widget.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
            ),
            Text(
              widget.page == 'ph'
                  ? '${data.ph}'
                  : widget.page == 'ppm'
                      ? '${data.ppm}'
                      : '${data.suhu} \u00B0C',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
            ),
            const Divider(),
            TextField(
              controller: startDateController,
              decoration: const InputDecoration(
                icon: Icon(Icons.calendar_today),
                labelText: 'Start Date',
                hintText: 'yyyy-mm-dd',
              ),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    //get today's date
                    firstDate: DateTime(2024),
                    lastDate: DateTime.now());

                if (pickedDate != null) {
                  String formattedDate =
                      DateFormat('yyyy-MM-dd').format(pickedDate);

                  setState(() {
                    startDateController.text = formattedDate;
                  });
                }
              },
            ),
            startDateController.text.isNotEmpty
                ? TextField(
                    controller: endDateController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.calendar_today),
                      labelText: 'End Date',
                      hintText: 'yyyy-mm-dd',
                    ),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          //get today's date
                          firstDate: DateTime(2024),
                          lastDate: DateTime.now());

                      if (pickedDate != null) {
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);

                        setState(() {
                          endDateController.text = formattedDate;
                        });
                      }
                    },
                  )
                : Container(),
            const Divider(),
            SfCartesianChart(
              primaryXAxis: const DateTimeAxis(),
              title: ChartTitle(text: 'Grafik ${widget.title}'),
              zoomPanBehavior: _zoomPanBehavior,
              series: <LineSeries<GraphData, dynamic>>[
                LineSeries(
                  dataSource: data.data?.where((e) {
                    if (startDateController.text.isEmpty &&
                        endDateController.text.isEmpty) {
                      return true;
                    }
                    if (endDateController.text.isEmpty) {
                      return e.tanggal!.compareTo(
                              DateTime.parse(startDateController.text)) >=
                          0;
                    }
                    return e.tanggal!.compareTo(
                                DateTime.parse(startDateController.text)) >=
                            0 &&
                        e.tanggal!.compareTo(
                                DateTime.parse(endDateController.text)) <=
                            0;
                  }).toList(),
                  xValueMapper: (GraphData data, _) => data.tanggal,
                  yValueMapper: (GraphData data, _) => widget.page == 'ph'
                      ? double.parse(data.value!.split(',')[0])
                      : widget.page == 'ppm'
                          ? double.parse(data.value!.split(',')[1])
                          : double.parse(data.value!.split(',')[2]),
                  dataLabelSettings: const DataLabelSettings(isVisible: true),
                  markerSettings: const MarkerSettings(isVisible: true),
                  animationDuration: 200,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
