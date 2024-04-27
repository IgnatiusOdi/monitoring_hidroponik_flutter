import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/data.dart';
import '../../services/mqtt_service.dart';
import '../../services/realtime_database_service.dart';
import 'nutrisi_slider.dart';

class Nutrisi extends StatefulWidget {
  final String node;
  final RealtimeDatabaseService service;

  const Nutrisi({super.key, required this.node, required this.service});

  @override
  State<Nutrisi> createState() => _NutrisiState();
}

class _NutrisiState extends State<Nutrisi> {
  bool loading = false;
  bool success = false;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double width = MediaQuery.of(context).size.width;

    return StreamBuilder(
      stream: widget.service.getNode(widget.node),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        var data = Data.fromJson(
            snapshot.data!.snapshot.value as Map<dynamic, dynamic>);
        final diff = DateTime.now().difference(data.penambahanPPM!).inDays;

        return Column(
          children: [
            Text(
              widget.node,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            const Text(
              r'Nutrisi Terakhir Ditambahkan :',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            Text(
              diff == 0 ? 'HARI INI' : '$diff HARI yang lalu',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
            ),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  loading = true;
                  success = false;
                });
                final prefs = await SharedPreferences.getInstance();
                await MqttService()
                    .publish(widget.node,
                        prefs.getDouble(widget.node)!.round().toString())
                    .then((_) => setState(() {
                          loading = false;
                          success = true;
                        }));
              },
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: width > 475
                    ? const EdgeInsets.all(60)
                    : const EdgeInsets.all(40),
                backgroundColor: theme.primaryColor,
                foregroundColor: theme.colorScheme.onPrimary,
              ),
              child: const Text(
                'TAMBAH\nNUTRISI',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            Text('PPM saat ini : ${data.ppm}',
                style: const TextStyle(fontSize: 24)),
            loading ? const CircularProgressIndicator() : Container(),
            success
                ? Text('Berhasil mengirim perintah',
                    style: TextStyle(fontSize: 20, color: theme.primaryColor))
                : Container(),
            NutrisiSlider(node: widget.node),
          ],
        );
      },
    );
  }
}
