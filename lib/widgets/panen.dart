import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../model/panen_data.dart';

class Panen extends StatelessWidget {
  final String title;

  // DatabaseReference
  final Future<DatabaseEvent> ref;

  const Panen({super.key, required this.title, required this.ref});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ref,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          var data = PanenData.fromJson(
              snapshot.data!.snapshot.value as Map<String, dynamic>);
          final diff1 = data.harvest1?.difference(DateTime.now()).inDays;
          final diff2 = data.harvest2?.difference(DateTime.now()).inDays;

          return Column(
            children: [
              Text(
                title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              Text(
                data.tanaman!,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
              ),
              Text(
                '$diff1 - $diff2 hari lagi',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
            ],
          );
        }

        return const Center(child: Text('Error'));
      },
    );
  }
}
