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
  Data? data;
  int? diff1;
  int? diff2;

  void getData() {
    context
        .read<RealtimedbRepository>()
        .getStreamNode(widget.node)
        .listen((snapshot) {
      if (snapshot.snapshot.value != null) {
        setState(() {
          data =
              Data.fromJson(snapshot.snapshot.value as Map<dynamic, dynamic>);
          diff1 = data!.tanaman!.panen1!.difference(DateTime.now()).inDays;
          diff2 = data!.tanaman!.panen2!.difference(DateTime.now()).inDays;
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
  }

  @override
  Widget build(BuildContext context) {
    return data != null
        ? Container(
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
                  data!.tanaman!.jenis!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                  ),
                ),
                if (diff2! <= 0)
                  const Text('Siap Panen', style: TextStyle(fontSize: 24))
                else if (diff1! <= 0)
                  Text(
                    'Bisa Panen hingga $diff2 hari',
                    style: const TextStyle(fontSize: 24),
                  )
                else
                  Text(
                    '$diff1 - $diff2 hari',
                    style: const TextStyle(fontSize: 24),
                  )
              ],
            ),
          )
        : const Center(child: CircularProgressIndicator());
  }
}
