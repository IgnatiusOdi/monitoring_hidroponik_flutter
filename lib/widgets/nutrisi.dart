import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../model/nutrisi_data.dart';

class Nutrisi extends StatefulWidget {
  final String title;

  // DatabaseReference
  final DatabaseReference ref;

  const Nutrisi({super.key, required this.title, required this.ref});

  @override
  State<Nutrisi> createState() => _NutrisiState();
}

class _NutrisiState extends State<Nutrisi> {
  double _currentSliderValue = 560;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return FutureBuilder(
        future: widget.ref.get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            var data = NutrisiData.fromJson(
                snapshot.data!.value as Map<String, dynamic>);
            final diff = DateTime.now().difference(data.lastAdded!).inDays;

            return Column(
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 24),
                ),
                const Text(
                  r'Nutrisi Terakhir Ditambahkan :',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                Text(
                  diff == 0 ? 'HARI INI' : '$diff HARI yang lalu',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 32),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await widget.ref.update({
                      'lastAdded': DateTime.now().toString().split(' ').first
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(60),
                    backgroundColor: theme.primaryColor,
                    foregroundColor:
                        theme.colorScheme.onPrimary, // <-- Splash color
                  ),
                  child: const Text(
                    'TAMBAH\nNUTRISI',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                Slider(
                  value: _currentSliderValue,
                  min: 560,
                  max: 1400,
                  divisions: 10,
                  label: _currentSliderValue.round().toString(),
                  onChanged: (value) {
                    setState(() {
                      _currentSliderValue = value;
                    });
                  },
                )
              ],
            );
          }

          return const Center(child: Text('Error'));
        });
  }
}
