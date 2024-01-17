import 'dart:html';

import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: theme.colorScheme.primaryContainer,
            child: SizedBox(
              width: width,
              height: 200,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('NOTIFIKASI'),
                    Card(
                      color: Colors.redAccent,
                      child: SizedBox(
                        width: width * 0.8,
                        height: 40,
                        child: const Text('AIR MELEWATI BATAS SENSOR!'),
                      ),
                    ),
                    Card(
                      color: Colors.yellowAccent,
                      child: SizedBox(
                        width: width * 0.8,
                        height: 40,
                        child: const Text('SUHU AIR MELEWATI BATAS!'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Text('SELADA - 34 hari lagi'),
          Row(children: [
            Card(
              color: theme.colorScheme.primaryContainer,
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                splashColor: Colors.blue.withAlpha(30),
                onTap: () {
                  debugPrint('PPM');
                },
                child: const SizedBox(
                  width: 300,
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
                  debugPrint('Suhu Air');
                },
                child: const SizedBox(
                  width: 300,
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
          ]),
          Card(
            color: theme.colorScheme.primaryContainer,
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              splashColor: Colors.blue.withAlpha(30),
              onTap: () {
                debugPrint('Suhu Air');
              },
              child: const SizedBox(
                width: 300,
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
    );
  }
}
