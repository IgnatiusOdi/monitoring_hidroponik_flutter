import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../model/tanaman.dart';

class Panen extends StatelessWidget {
  final String title;

  // DatabaseReference
  final DatabaseReference ref;

  const Panen({super.key, required this.title, required this.ref});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: ref.onValue,
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
                title,
                style: const TextStyle(fontSize: 24),
              ),
              Text(
                data.jenis!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                ),
              ),
              Text(
                '$diff1 - $diff2 hari lagi',
                style: const TextStyle(fontSize: 24),
              ),
            ],
          ),
        );
      },
    );
  }
}
