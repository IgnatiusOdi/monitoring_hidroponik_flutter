import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/realtime_database_service.dart';
import 'nutrisi.dart';

class NutrisiScreen extends StatelessWidget {
  const NutrisiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service =
        Provider.of<RealtimeDatabaseService>(context, listen: false);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Nutrisi(node: r'node1', service: service),
                const Divider(),
                Nutrisi(node: r'node2', service: service),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
