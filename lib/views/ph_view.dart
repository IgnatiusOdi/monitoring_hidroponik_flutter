import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/graph.dart';

class PhView extends StatelessWidget {
  final String node;

  const PhView({super.key, required this.node});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    const page = 'PPM';
    final ref = FirebaseDatabase.instance.ref('$node/ph/status').once();

    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.goNamed('home');
            },
          ),
          title: Text('Kadar PPM $node'),
          backgroundColor: theme.primaryColor),
      body: SingleChildScrollView(
        child: Graph(page: page, title: 'pH Air $node', ref: ref),
      ),
    );
  }
}
