import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'history.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
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
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text('node1',
                  style: TextStyle(fontSize: 20)),
              History(node: r'node1'),
              Divider(),
              Text('node2',
                  style: TextStyle(fontSize: 20)),
              History(node: r'node2'),
            ],
          ),
        ),
      ),
    );
  }
}
