import 'package:flutter/material.dart';

import '../../models/tanaman.dart';
import '../../repository/realtimedb_repository.dart';

class Panen extends StatelessWidget {
  final String node;
  final RealtimedbRepository repository;

  const Panen({super.key, required this.node, required this.repository});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: repository.getStreamNode('$node/tanaman'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        var data = TanamanData.fromJson(
            snapshot.data!.snapshot.value as Map<dynamic, dynamic>);
        final diff1 = data.panen1?.difference(DateTime.now()).inDays;
        final diff2 = data.panen2?.difference(DateTime.now()).inDays;

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
                node,
                style: const TextStyle(fontSize: 24),
              ),
              Text(
                data.jenis!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                ),
              ),
              diff2! <= 0
                  ? const Text('Siap Panen', style: TextStyle(fontSize: 24))
                  : diff1! <= 0
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
