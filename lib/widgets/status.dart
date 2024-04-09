import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../model/data.dart';

class Status extends StatelessWidget {
  final String node;

  // DatabaseReference
  final DatabaseReference ref;

  const Status({super.key, required this.node, required this.ref});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double width = MediaQuery.of(context).size.width;

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(node,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    decoration: TextDecoration.underline)),
            Row(
              children: [
                const Text('Status: ', style: TextStyle(fontSize: 24)),
                Container(
                  width: 20,
                  height: 20,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                      color: data.status == true
                          ? theme.primaryColor
                          : Colors.grey,
                      shape: BoxShape.circle),
                ),
                Text(
                  data.status == true ? 'ON' : 'OFF',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 24),
                ),
              ],
            ),
            data.status!
                ? Row(
                    children: [
                      Card(
                        color: theme.colorScheme.primaryContainer,
                        clipBehavior: Clip.hardEdge,
                        child: InkWell(
                          splashColor: Colors.blue.withAlpha(30),
                          onTap: () {
                            context
                                .goNamed('ppm', pathParameters: {'node': node});
                          },
                          child: SizedBox(
                            width: 200,
                            height: 100,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('PPM',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24)),
                                Text('${data.ppm}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 32)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Card(
                        color: theme.colorScheme.primaryContainer,
                        clipBehavior: Clip.hardEdge,
                        child: InkWell(
                          splashColor: Colors.blue.withAlpha(30),
                          onTap: () {
                            context
                                .goNamed('ph', pathParameters: {'node': node});
                          },
                          child: SizedBox(
                            width: 200,
                            height: 100,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('pH Air',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24)),
                                Text('${data.ph}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 32)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Card(
                        color: theme.colorScheme.primaryContainer,
                        clipBehavior: Clip.hardEdge,
                        child: InkWell(
                          splashColor: Colors.blue.withAlpha(30),
                          onTap: () {
                            context.goNamed('suhu',
                                pathParameters: {'node': node});
                          },
                          child: SizedBox(
                            width: 200,
                            height: 100,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Suhu Air',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24)),
                                Text('${data.suhu} \u00B0C',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 32)),
                              ],
                            ),
                          ),
                        ),
                      ),
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
                          ],
                        ),
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

class NotifikasiCard extends StatelessWidget {
  final String message;
  final Color? color;
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
