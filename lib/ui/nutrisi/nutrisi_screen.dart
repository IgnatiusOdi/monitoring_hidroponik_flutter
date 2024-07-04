import 'package:flutter/material.dart';

import 'nutrisi.dart';

class NutrisiScreen extends StatelessWidget {
  const NutrisiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Nutrisi(node: r'node1'),
                Divider(),
                Nutrisi(node: r'node2'),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: IconButton(
        onPressed: () {},
        tooltip: "Mohon ditunggu setelah tambah nutrisi",
        icon: const Icon(Icons.info),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }
}
