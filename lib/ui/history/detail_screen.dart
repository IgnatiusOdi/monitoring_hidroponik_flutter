import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../models/graph_data.dart';
import '../../repository/firestore_repository.dart';

class DetailScreen extends StatefulWidget {
  final String node;
  final String docid;
  final String tanggal;

  const DetailScreen({
    super.key,
    required this.node,
    required this.docid,
    required this.tanggal,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  List<GraphData>? data;

  late ZoomPanBehavior _zoomPanBehavior;
  late TrackballBehavior _trackballBehavior;
  final tanggalAwalController = TextEditingController();
  final tanggalAkhirController = TextEditingController();

  void getData() async {
    await context
        .read<FirestoreRepository>()
        .getFutureHistory(widget.node, widget.docid, widget.tanggal)
        .then((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        setState(() {
          data = snapshot.docs
              .map((e) => GraphData(
                  DateTime.parse(e.data().toString().substring(1, 24)),
                  e
                      .data()
                      .toString()
                      .substring(27, e.data().toString().length - 1)))
              .toList();
          data!.sort((a, b) => a.tanggal!.compareTo(b.tanggal!));
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
    });
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
  void dispose() {
    tanggalAwalController.dispose();
    tanggalAkhirController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.goNamed('history');
          },
        ),
        title: const Text('Detail History'),
        foregroundColor: theme.colorScheme.surface,
        backgroundColor: theme.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
            child: data != null
                ? Column(
                    children: [
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
                            (value) => setState(() =>
                                tanggalAwalController.text =
                                    DateFormat('yyyy-MM-dd').format(value!)),
                          );
                        },
                      ),
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
                                  firstDate:
                                      DateTime.parse(tanggalAwalController.text)
                                          .add(const Duration(days: 1)),
                                  lastDate: DateTime.now()
                                      .add(const Duration(days: 1)),
                                ).then(
                                  (value) => setState(() =>
                                      tanggalAkhirController.text =
                                          DateFormat('yyyy-MM-dd')
                                              .format(value!)),
                                );
                              },
                            )
                          : Container(),
                      const Divider(),
                      SfCartesianChart(
                        primaryXAxis: const DateTimeAxis(),
                        title: ChartTitle(text: 'Grafik ${widget.tanggal}'),
                        zoomPanBehavior: _zoomPanBehavior,
                        trackballBehavior: _trackballBehavior,
                        legend: const Legend(
                          isVisible: true,
                          position: LegendPosition.bottom,
                        ),
                        series: <CartesianSeries<GraphData, dynamic>>[
                          FastLineSeries(
                            name: 'pH',
                            dataSource: data!.where((e) {
                              if (tanggalAwalController.text.isEmpty &&
                                  tanggalAkhirController.text.isEmpty) {
                                return true;
                              }
                              if (tanggalAkhirController.text.isEmpty) {
                                return e.tanggal!.compareTo(DateTime.parse(
                                        tanggalAwalController.text)) >=
                                    0;
                              }
                              return e.tanggal!.compareTo(DateTime.parse(
                                          tanggalAwalController.text)) >=
                                      0 &&
                                  e.tanggal!.compareTo(DateTime.parse(
                                          tanggalAkhirController.text)) <=
                                      0;
                            }).toList(),
                            xValueMapper: (GraphData data, _) => data.tanggal,
                            yValueMapper: (GraphData data, _) =>
                                double.parse(data.value!.split(",")[0]),
                            dataLabelSettings:
                                const DataLabelSettings(isVisible: true),
                            markerSettings:
                                const MarkerSettings(isVisible: true),
                            animationDuration: 0,
                          ),
                          FastLineSeries(
                            name: 'ppm',
                            dataSource: data!.where((e) {
                              if (tanggalAwalController.text.isEmpty &&
                                  tanggalAkhirController.text.isEmpty) {
                                return true;
                              }
                              if (tanggalAkhirController.text.isEmpty) {
                                return e.tanggal!.compareTo(DateTime.parse(
                                        tanggalAwalController.text)) >=
                                    0;
                              }
                              return e.tanggal!.compareTo(DateTime.parse(
                                          tanggalAwalController.text)) >=
                                      0 &&
                                  e.tanggal!.compareTo(DateTime.parse(
                                          tanggalAkhirController.text)) <=
                                      0;
                            }).toList(),
                            xValueMapper: (GraphData data, _) => data.tanggal,
                            yValueMapper: (GraphData data, _) =>
                                double.parse(data.value!.split(",")[1]),
                            dataLabelSettings:
                                const DataLabelSettings(isVisible: true),
                            markerSettings:
                                const MarkerSettings(isVisible: true),
                            animationDuration: 0,
                          ),
                          FastLineSeries(
                            name: 'suhu',
                            dataSource: data!.where((e) {
                              if (tanggalAwalController.text.isEmpty &&
                                  tanggalAkhirController.text.isEmpty) {
                                return true;
                              }
                              if (tanggalAkhirController.text.isEmpty) {
                                return e.tanggal!.compareTo(DateTime.parse(
                                        tanggalAwalController.text)) >=
                                    0;
                              }
                              return e.tanggal!.compareTo(DateTime.parse(
                                          tanggalAwalController.text)) >=
                                      0 &&
                                  e.tanggal!.compareTo(DateTime.parse(
                                          tanggalAkhirController.text)) <=
                                      0;
                            }).toList(),
                            xValueMapper: (GraphData data, _) => data.tanggal,
                            yValueMapper: (GraphData data, _) =>
                                double.parse(data.value!.split(",")[2]),
                            dataLabelSettings:
                                const DataLabelSettings(isVisible: true),
                            markerSettings:
                                const MarkerSettings(isVisible: true),
                            animationDuration: 0,
                          ),
                        ],
                      ),
                    ],
                  )
                : const Text(
                    'Tidak ada data',
                    style: TextStyle(fontSize: 18),
                  )),
      ),
    );
  }
}
