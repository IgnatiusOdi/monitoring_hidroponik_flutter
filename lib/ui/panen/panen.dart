import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/data.dart';
import '../../repository/realtimedb_repository.dart';

class Panen extends StatefulWidget {
  final String node;

  const Panen({super.key, required this.node});

  @override
  State<Panen> createState() => _PanenState();
}

class _PanenState extends State<Panen> {
  late Stream<DatabaseEvent> stream;

  @override
  void initState() {
    stream = context.read<RealtimedbRepository>().getStreamNode(widget.node);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
        final diff1 = data.tanaman!.panen1!.difference(DateTime.now()).inDays;
        final diff2 = data.tanaman!.panen2!.difference(DateTime.now()).inDays;

        return Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Text(
                widget.node,
                style: const TextStyle(fontSize: 24),
              ),
              Text(
                data.tanaman!.jenis!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                ),
              ),
              diff2 <= 0
                  ? const Text('Siap Panen', style: TextStyle(fontSize: 24))
                  : diff1 <= 0
                      ? Text(
                          'Bisa Panen hingga $diff2 hari',
                          style: const TextStyle(fontSize: 24),
                        )
                      : Text(
                          '$diff1 - $diff2 hari',
                          style: const TextStyle(fontSize: 24),
                        )
            ],
          ),
        );
      },
    );
  }
}
