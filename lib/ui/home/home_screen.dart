import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/realtime_database_service.dart';
import 'status.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service =
        Provider.of<RealtimeDatabaseService>(context, listen: false);

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
              Status(node: r'node1', service: service),
              Status(node: r'node2', service: service),
            ],
          ),
        ),
      ),
    );
  }
}
