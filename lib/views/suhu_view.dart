import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/graph.dart';

class SuhuView extends StatelessWidget {
  final String node;

  const SuhuView({super.key, required this.node});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    const page = 'Suhu (\u00B0C)';
    final ref = FirebaseDatabase.instance.ref(node);

    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.goNamed('home');
            },
          ),
          title: Text('Suhu $node'),
          backgroundColor: theme.primaryColor),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Graph(page: page, title: 'Suhu Air $node', ref: ref),
        ),
      ),
    );
  }
}
