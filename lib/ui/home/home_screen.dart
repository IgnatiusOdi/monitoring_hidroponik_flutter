import 'package:flutter/material.dart';
import 'status.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'STATUS',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28),
              ),
              Divider(),
              Status(node: r'node1'),
              Status(node: r'node2'),
            ],
          ),
        ),
      ),
    );
  }
}
