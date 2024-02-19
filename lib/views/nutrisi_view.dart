import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../widgets/nutrisi.dart';

class NutrisiView extends StatelessWidget {
  const NutrisiView({super.key});

  @override
  Widget build(BuildContext context) {
    final ref1 = FirebaseDatabase.instance.ref('node1/nutrisi');
    final ref2 = FirebaseDatabase.instance.ref('node2/nutrisi');

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Nutrisi(title: r'Node 1', ref: ref1),
              const Divider(),
              Nutrisi(title: r'Node 2', ref: ref2),
            ],
          ),
        ),
      ),
    );
  }
}
