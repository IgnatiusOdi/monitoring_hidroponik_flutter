import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/realtimedb_repository.dart';
import 'nutrisi.dart';

class NutrisiScreen extends StatelessWidget {
  const NutrisiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = RepositoryProvider.of<RealtimedbRepository>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Nutrisi(node: r'node1', repository: repository),
                const Divider(),
                Nutrisi(node: r'node2', repository: repository),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
