import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../widgets/nutrisi.dart';

class NutrisiView extends StatelessWidget {
  const NutrisiView({super.key});

  @override
  Widget build(BuildContext context) {
    final ref1 = FirebaseDatabase.instance.ref('node1');
    final ref2 = FirebaseDatabase.instance.ref('node2');

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Nutrisi(title: r'node1', ref: ref1),
                const Divider(),
                Nutrisi(title: r'node2', ref: ref2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
