import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../services/realtime_database_service.dart';
import 'graph.dart';

class GraphScreen extends StatelessWidget {
  final String page;
  final String node;

  const GraphScreen({super.key, required this.page, required this.node});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final service =
        Provider.of<RealtimeDatabaseService>(context, listen: false);
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
          child: Graph(page: page, title: title, node: node, service: service),
        ),
      ),
    );
  }
}
