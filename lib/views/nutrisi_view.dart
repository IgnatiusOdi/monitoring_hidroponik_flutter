import 'package:flutter/material.dart';

class NutrisiView extends StatelessWidget {
  const NutrisiView({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Nutrisi Terakhir Ditambahkan :',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
            const Text('3 HARI yang lalu',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32)),
            ElevatedButton(
                onPressed: () {},
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
                )),
          ],
        ),
      ),
    );
  }
}
