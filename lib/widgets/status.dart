import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

class Status extends StatelessWidget {
  final String node;

  // DatabaseReference
  final Future<DatabaseEvent> ref;

  const Status({super.key, required this.node, required this.ref});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return FutureBuilder(
      future: ref,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          var data = snapshot.data!.snapshot.value;
          print(data);

          return Column(
            children: [
              Text(
                'STATUS $node',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                        color: data == true ? theme.primaryColor : Colors.grey,
                        shape: BoxShape.circle),
                  ),
                  Text(
                    data == true ? 'ON' : 'OFF',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    color: theme.colorScheme.primaryContainer,
                    clipBehavior: Clip.hardEdge,
                    child: InkWell(
                      splashColor: Colors.blue.withAlpha(30),
                      onTap: () {
                        context.goNamed('ppm', pathParameters: {'node': node});
                      },
                      child: const SizedBox(
                        width: 200,
                        height: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('PPM',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 24)),
                            Text('560',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 32)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Card(
                    color: theme.colorScheme.primaryContainer,
                    clipBehavior: Clip.hardEdge,
                    child: InkWell(
                      splashColor: Colors.blue.withAlpha(30),
                      onTap: () {
                        context.goNamed('ph', pathParameters: {'node': node});
                      },
                      child: const SizedBox(
                        width: 200,
                        height: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('pH Air',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 24)),
                            Text('6,0 C',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 32)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Card(
                    color: theme.colorScheme.primaryContainer,
                    clipBehavior: Clip.hardEdge,
                    child: InkWell(
                      splashColor: Colors.blue.withAlpha(30),
                      onTap: () {
                        context.goNamed('suhu', pathParameters: {'node': node});
                      },
                      child: const SizedBox(
                        width: 200,
                        height: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Suhu Air',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 24)),
                            Text('25,1 \u00B0C',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 32)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        }

        return const Center(child: Text('Error'));
      },
    );
  }
}
