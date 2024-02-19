import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../widgets/status.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    final ref1 = FirebaseDatabase.instance.ref('node1/status').once();
    final ref2 = FirebaseDatabase.instance.ref('node2/status').once();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              color: theme.colorScheme.primaryContainer,
              child: SizedBox(
                width: width,
                height: 200,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'NOTIFIKASI',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                      Card(
                        color: Colors.redAccent,
                        child: SizedBox(
                          width: width,
                          height: 40,
                          child: const Text('AIR MELEWATI BATAS SENSOR!'),
                        ),
                      ),
                      Card(
                        color: Colors.yellowAccent,
                        child: SizedBox(
                          width: width,
                          height: 40,
                          child: const Text('SUHU AIR MELEWATI BATAS!'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Status(node: 'node1', ref: ref1),
            Status(node: 'node2', ref: ref2),
          ],
        ),
      ),
    );
  }
}
