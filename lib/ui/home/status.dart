import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/data.dart';
import '../../repository/realtimedb_repository.dart';

class Status extends StatelessWidget {
  final String node;
  final RealtimedbRepository repository;

  const Status({super.key, required this.node, required this.repository});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return StreamBuilder(
      stream: repository.getStreamNode(node),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(node,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    decoration: TextDecoration.underline)),
            Row(
              children: [
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
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 24),
                ),
              ],
            ),
            data.status!
                ? GridView.count(
                    crossAxisCount: width > 475 ? 3 : 2,
                    childAspectRatio: width / (height / 2),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      StatusCard(theme.colorScheme.primaryContainer, node, 'ph',
                          'pH Air', data.ph!),
                      StatusCard(theme.colorScheme.primaryContainer, node,
                          'ppm', 'Kadar PPM', data.ppm!),
                      StatusCard(theme.colorScheme.primaryContainer, node,
                          'suhu', 'Suhu Air', '${data.suhu} \u00B0C'),
                    ],
                  )
                : Container(),
            data.status!
                ? Card(
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
                                  ? NotifikasiCard(
                                      'Ketinggian Air melewati batas!',
                                      Colors.redAccent,
                                      width)
                                  : Container(),

                              // PH
                              data.ph! < 5.5 || data.ph! > 6.5
                                  ? NotifikasiCard('pH Air melewati batas!',
                                      Colors.yellowAccent, width)
                                  : Container(),

                              // PPM
                              data.ppm! < data.tanaman!.ppmMin!.toInt() ||
                                      data.ppm! > data.tanaman!.ppmMax!.toInt()
                                  ? NotifikasiCard('Kadar PPM melewati batas!',
                                      Colors.yellowAccent, width)
                                  : Container(),

                              // SUHU
                              data.suhu! < 20 || data.suhu! > 25
                                  ? NotifikasiCard('Suhu Air melewati batas!',
                                      Colors.redAccent, width)
                                  : Container(),
                            ]),
                      ),
                    ),
                  )
                : Container(),
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
            pathParameters: {'page': page, 'node': node},
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
