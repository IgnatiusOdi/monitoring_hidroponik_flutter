import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/graph.dart';

class GraphView extends StatelessWidget {
  final String page;
  final String node;

  const GraphView({super.key, required this.page, required this.node});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ref = FirebaseDatabase.instance.ref(node);
    String title = page == 'ph'
        ? 'pH Air $node'
        : page == 'ppm'
            ? 'Kadar PPM $node'
            : 'Suhu Air $node';

    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.goNamed('home');
            },
          ),
          title: Text(title),
          backgroundColor: theme.primaryColor),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Graph(page: page, title: title, ref: ref),
        ),
      ),
    );
  }
}
