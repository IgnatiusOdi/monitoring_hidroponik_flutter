import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../widgets/panen.dart';

class PanenView extends StatelessWidget {
  const PanenView({super.key});

  @override
  Widget build(BuildContext context) {
    final ref1 = FirebaseDatabase.instance.ref('node1/panen').once();
    final ref2 = FirebaseDatabase.instance.ref('node2/panen').once();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(r'Perkiraan Waktu Panen',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Panen(title: r'Node 1', ref: ref1),
                  Panen(title: r'Node 2', ref: ref2),
                ],
              ),
              const Divider(),
              Table(
                border: TableBorder.all(),
                children: const [
                  TableRow(
                    children: [
                      TableCell(
                          child: Text(r'TANAMAN',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20))),
                      TableCell(
                          child: Text(r'PPM',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20))),
                      TableCell(
                          child: Text(r'WAKTU PANEN',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20)))
                    ],
                  ),
                  TableRow(
                    children: [
                      TableCell(
                          child: Text(r'Selada',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 20))),
                      TableCell(
                          child: Text(r'560 - 840',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 20))),
                      TableCell(
                          child: Text(r'30 - 40 hari',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 20)))
                    ],
                  ),
                  TableRow(
                    children: [
                      TableCell(
                          child: Text(r'Kangkung',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 20))),
                      TableCell(
                          child: Text(r'1050 - 1400',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 20))),
                      TableCell(
                          child: Text(r'21 - 25 hari',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 20)))
                    ],
                  ),
                  TableRow(
                    children: [
                      TableCell(
                          child: Text(r'Sawi',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 20))),
                      TableCell(
                          child: Text(r'1050 - 1400',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 20))),
                      TableCell(
                          child: Text(r'25 - 30 hari',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 20)))
                    ],
                  ),
                  TableRow(
                    children: [
                      TableCell(
                          child: Text(r'Pakcoy',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 20))),
                      TableCell(
                          child: Text(r'1050 - 1400',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 20))),
                      TableCell(
                          child: Text(r'40 - 45 hari',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 20)))
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
