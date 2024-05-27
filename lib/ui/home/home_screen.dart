import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/realtimedb_repository.dart';
import 'status.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = RepositoryProvider.of<RealtimedbRepository>(context);

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
              Status(node: r'node1', repository: repository),
              Status(node: r'node2', repository: repository),
            ],
          ),
        ),
      ),
    );
  }
}
