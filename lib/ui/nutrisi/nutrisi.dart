import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/data.dart';
import '../../repository/mqtt_repository.dart';
import '../../repository/realtimedb_repository.dart';
import 'nutrisi_slider.dart';

class Nutrisi extends StatefulWidget {
  final String node;

  const Nutrisi({super.key, required this.node});

  @override
  State<Nutrisi> createState() => _NutrisiState();
}

class _NutrisiState extends State<Nutrisi> {
  late Stream<DatabaseEvent> stream;
  bool loading = false;
  bool success = false;

  @override
  void initState() {
    stream = context.read<RealtimedbRepository>().getStreamNode(widget.node);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double width = MediaQuery.of(context).size.width;
    final mqttRepository = context.read<MqttRepository>();

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
        final diff = DateTime.now().difference(data.penambahanPPM!).inDays;

        var ppm = int.parse(data.data!.last.value!.split(',')[1]);

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
                await mqttRepository
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
            Text('PPM saat ini : $ppm', style: const TextStyle(fontSize: 24)),
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
