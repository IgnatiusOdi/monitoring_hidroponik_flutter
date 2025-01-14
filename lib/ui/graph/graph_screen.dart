import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'graph.dart';

class GraphScreen extends StatelessWidget {
  final String node;
  final String page;

  const GraphScreen({
    super.key,
    required this.node,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
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
          foregroundColor: theme.colorScheme.surface,
          backgroundColor: theme.primaryColor),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Graph(
            page: page,
            title: title,
            node: node,
          ),
        ),
      ),
    );
  }
}
