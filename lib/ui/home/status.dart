import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../models/data.dart';
import '../../repository/realtimedb_repository.dart';

class Status extends StatefulWidget {
  final String node;

  const Status({super.key, required this.node});

  @override
  State<Status> createState() => _StatusState();
}

class _StatusState extends State<Status> {
  late Stream<DatabaseEvent> stream;

  @override
  void initState() {
    stream = context.read<RealtimedbRepository>().getStreamNode(widget.node);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData) {
          return const Center(child: Text('No data'));
        }

        var data = Data.fromJson(
            snapshot.data!.snapshot.value as Map<dynamic, dynamic>);

        var ph = double.parse(data.data!.last.value!.split(',')[0]);
        var ppm = int.parse(data.data!.last.value!.split(',')[1]);
        var suhu = double.parse(data.data!.last.value!.split(',')[2]);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.node,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    decoration: TextDecoration.underline)),
            Row(children: [
              const Text('Ketinggian Air: ', style: TextStyle(fontSize: 24)),
              Container(
                width: 20,
                height: 20,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                    color:
                        data.tinggiAir == 1 ? theme.primaryColor : Colors.red,
                    shape: BoxShape.circle),
              ),
              Text(
                data.tinggiAir == 1 ? 'Aman' : 'Tidak Aman',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
            ]),
            GridView.count(
                crossAxisCount: width > 475 ? 3 : 2,
                childAspectRatio: width / (height / 2),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  StatusCard(theme.colorScheme.primaryContainer, widget.node,
                      'ph', 'pH Air', ph),
                  StatusCard(theme.colorScheme.primaryContainer, widget.node,
                      'ppm', 'Kadar PPM', ppm),
                  StatusCard(theme.colorScheme.primaryContainer, widget.node,
                      'suhu', 'Suhu Air', '$suhu \u00B0C'),
                ]),
            Card(
              color: theme.colorScheme.primaryContainer,
              child: SizedBox(
                width: width,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Notifikasi',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24),
                        ),

                        // TINGGI AIR
                        data.tinggiAir == 0
                            ? NotifikasiCard('Ketinggian Air melewati batas!',
                                Colors.redAccent, width)
                            : Container(),

                        // PH
                        ph < 5.5 || ph > 6.5
                            ? NotifikasiCard('pH Air melewati batas!',
                                Colors.yellowAccent, width)
                            : Container(),

                        // PPM
                        ppm < data.tanaman!.ppmMin!.toInt() ||
                                ppm > data.tanaman!.ppmMax!.toInt()
                            ? NotifikasiCard('Kadar PPM melewati batas!',
                                Colors.yellowAccent, width)
                            : Container(),

                        // SUHU
                        suhu < 20 || suhu > 25
                            ? NotifikasiCard('Suhu Air melewati batas!',
                                Colors.redAccent, width)
                            : Container(),
                      ]),
                ),
              ),
            ),
            const Divider()
          ],
        );
      },
    );
  }
}

class StatusCard extends StatelessWidget {
  final Color color;
  final String node;
  final String page;
  final String title;
  final dynamic data;

  const StatusCard(this.color, this.node, this.page, this.title, this.data,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          context.goNamed(
            'graph',
            pathParameters: {'node': node, 'page': page},
          );
        },
        child: SizedBox(
          width: 150,
          height: 100,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
            Text('$data',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 32)),
          ]),
        ),
      ),
    );
  }
}

class NotifikasiCard extends StatelessWidget {
  final String message;
  final Color color;
  final double width;

  const NotifikasiCard(this.message, this.color, this.width, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: SizedBox(
        width: width,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(message),
          ),
        ),
      ),
    );
  }
}
