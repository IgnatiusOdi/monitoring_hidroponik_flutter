import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../model/tanaman.dart';
import '../widgets/panen.dart';

class PanenView extends StatelessWidget {
  const PanenView({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final ref1 = FirebaseDatabase.instance.ref('node1/tanaman');
    final ref2 = FirebaseDatabase.instance.ref('node2/tanaman');

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              r'Perkiraan Waktu Panen',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
            ),
            const Divider(),
            width > 475
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Panen(title: r'node1', ref: ref1),
                      Panen(title: r'node2', ref: ref2),
                    ],
                  )
                : Column(
                    children: [
                      Panen(title: r'node1', ref: ref1),
                      Panen(title: r'node2', ref: ref2),
                    ],
                  ),
            const Divider(),
            Table(
              border: TableBorder.all(),
              children: [
                const TableRow(
                  children: [
                    TableCell(
                        child: Text(
                      r'TANAMAN',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    )),
                    TableCell(
                        child: Text(
                      r'PPM',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    )),
                    TableCell(
                        child: Text(
                      r'WAKTU PANEN',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ))
                  ],
                ),
                for (var tanaman in Tanaman.values)
                  TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                              '${tanaman.nama.characters.first.toUpperCase()}${tanaman.nama.characters.skip(1)}',
                              style: const TextStyle(fontSize: 16)),
                        ),
                      ),
                      TableCell(
                          child: Text('${tanaman.ppmMin} - ${tanaman.ppmMax}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 16))),
                      TableCell(
                          child: Text(
                              '${tanaman.panen1} - ${tanaman.panen2} hari',
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 16)))
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
