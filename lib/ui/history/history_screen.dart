import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../repository/firestore_repository.dart';
import 'history.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final repository = RepositoryProvider.of<FirestoreRepository>(context);

    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.goNamed('home');
            },
          ),
          title: const Text('History'),
          foregroundColor: theme.colorScheme.surface,
          backgroundColor: theme.primaryColor),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'node1',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
              ),
              History(node: r'node1', repository: repository),
              const Divider(),
              const Text(
                'node2',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
              ),
              History(node: r'node2', repository: repository),
            ],
          ),
        ),
      ),
    );
  }
}
