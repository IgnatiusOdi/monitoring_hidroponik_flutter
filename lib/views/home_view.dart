import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../widgets/status.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final ref1 = FirebaseDatabase.instance.ref('node1');
    final ref2 = FirebaseDatabase.instance.ref('node2');

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                'STATUS',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
              ),
              const Divider(),
              Status(node: 'node1', ref: ref1),
              Status(node: 'node2', ref: ref2),
            ],
          ),
        ),
      ),
    );
  }
}
