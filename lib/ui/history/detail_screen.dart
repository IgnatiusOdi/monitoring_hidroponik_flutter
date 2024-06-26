import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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
          enable: true, color: Colors.green, format: 'point.x'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final repository = RepositoryProvider.of<FirestoreRepository>(context);

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
          backgroundColor: theme.primaryColor),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: StreamBuilder(
            stream: repository.getHistory(
                widget.node, widget.docid, widget.tanggal),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              var data = snapshot.data!.docs
                  .map((e) => GraphData(DateTime.parse(e.data().keys.first),
                      e.data().values.first))
                  .toList();
              data.sort((a, b) => a.tanggal!.compareTo(b.tanggal!));

              return SfCartesianChart(
                primaryXAxis: const DateTimeAxis(),
                title: const ChartTitle(text: 'Grafik'),
                zoomPanBehavior: _zoomPanBehavior,
                trackballBehavior: _trackballBehavior,
                legend: const Legend(
                  isVisible: true,
                  position: LegendPosition.bottom,
                ),
                series: <CartesianSeries<GraphData, dynamic>>[
                  FastLineSeries(
                    name: 'pH',
                    dataSource: data,
                    xValueMapper: (GraphData data, _) => data.tanggal,
                    yValueMapper: (GraphData data, _) =>
                        double.parse(data.value!.split(",")[0]),
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                    markerSettings: const MarkerSettings(isVisible: true),
                    animationDuration: 0,
                  ),
                  FastLineSeries(
                    name: 'ppm',
                    dataSource: data,
                    xValueMapper: (GraphData data, _) => data.tanggal,
                    yValueMapper: (GraphData data, _) =>
                        double.parse(data.value!.split(",")[1]),
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                    markerSettings: const MarkerSettings(isVisible: true),
                    animationDuration: 0,
                  ),
                  FastLineSeries(
                    name: 'suhu',
                    dataSource: data,
                    xValueMapper: (GraphData data, _) => data.tanggal,
                    yValueMapper: (GraphData data, _) =>
                        double.parse(data.value!.split(",")[2]),
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                    markerSettings: const MarkerSettings(isVisible: true),
                    animationDuration: 0,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
