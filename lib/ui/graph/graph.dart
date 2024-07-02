import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../models/data.dart';
import '../../models/graph_data.dart';
import '../../repository/realtimedb_repository.dart';

class Graph extends StatefulWidget {
  // pH Air, Kadar PPM, Suhu Air
  final String title;

  // ph, ppm, suhu (\u00B0C)
  final String page;

  final String node;
  final RealtimedbRepository repository;

  const Graph({
    super.key,
    required this.page,
    required this.title,
    required this.node,
    required this.repository,
  });

  @override
  State<Graph> createState() => _GraphState();
}

class _GraphState extends State<Graph> {
  late ZoomPanBehavior _zoomPanBehavior;
  late TrackballBehavior _trackballBehavior;
  final tanggalAwalController = TextEditingController();
  final tanggalAkhirController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _zoomPanBehavior = ZoomPanBehavior(
      enableMouseWheelZooming: true,
      enablePinching: true,
      zoomMode: ZoomMode.x,
      enablePanning: true,
    );
    _trackballBehavior = TrackballBehavior(
      enable: true,
      activationMode: ActivationMode.singleTap,
      lineType: TrackballLineType.vertical,
      tooltipSettings: const InteractiveTooltip(
        enable: true,
        color: Colors.green,
        format: 'point.x',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.repository.getStreamNode(widget.node),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        var data = Data.fromJson(
            snapshot.data!.snapshot.value as Map<dynamic, dynamic>);
        data.data!.sort((a, b) => a.tanggal!.compareTo(b.tanggal!));

        var ph = data.data!.last.value!.split(',')[0];
        var ppm = data.data!.last.value!.split(',')[1];
        var suhu = data.data!.last.value!.split(',')[2];

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
            ),
            Text(
              widget.page == 'ph'
                  ? ph
                  : widget.page == 'ppm'
                      ? ppm
                      : '$suhu \u00B0C',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
            ),
            const Divider(),
            TextField(
                controller: tanggalAwalController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.calendar_today),
                  labelText: 'Tanggal Awal',
                  hintText: 'yyyy-mm-dd',
                ),
                readOnly: true,
                onTap: () {
                  showDatePicker(
                    context: context,
                    firstDate: DateTime(2024),
                    lastDate: DateTime.now(),
                  ).then(
                    (value) => setState(() => tanggalAwalController.text =
                        DateFormat('yyyy-MM-dd').format(value!)),
                  );
                }),
            tanggalAwalController.text.isNotEmpty
                ? TextField(
                    controller: tanggalAkhirController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.calendar_today),
                      labelText: 'Tanggal Akhir',
                      hintText: 'yyyy-mm-dd',
                    ),
                    readOnly: true,
                    onTap: () {
                      showDatePicker(
                        context: context,
                        firstDate: DateTime.parse(tanggalAwalController.text)
                            .add(const Duration(days: 1)),
                        lastDate: DateTime.now().add(const Duration(days: 1)),
                      ).then(
                        (value) => setState(() => tanggalAkhirController.text =
                            DateFormat('yyyy-MM-dd').format(value!)),
                      );
                    },
                  )
                : Container(),
            const Divider(),
            SfCartesianChart(
              primaryXAxis: const DateTimeAxis(),
              title: ChartTitle(text: 'Grafik ${widget.title}'),
              zoomPanBehavior: _zoomPanBehavior,
              trackballBehavior: _trackballBehavior,
              series: <CartesianSeries<GraphData, dynamic>>[
                FastLineSeries(
                  dataSource: data.data?.where((e) {
                    if (tanggalAwalController.text.isEmpty &&
                        tanggalAkhirController.text.isEmpty) {
                      return true;
                    }
                    if (tanggalAkhirController.text.isEmpty) {
                      return e.tanggal!.compareTo(
                              DateTime.parse(tanggalAwalController.text)) >=
                          0;
                    }
                    return e.tanggal!.compareTo(
                                DateTime.parse(tanggalAwalController.text)) >=
                            0 &&
                        e.tanggal!.compareTo(
                                DateTime.parse(tanggalAkhirController.text)) <=
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
                  animationDuration: 0,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
