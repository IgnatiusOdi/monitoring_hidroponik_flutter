import 'package:flutter/material.dart';
import '../../models/tanaman.dart';
import 'panen.dart';
import '../../utils/string_utils.dart';

class PanenScreen extends StatelessWidget {
  const PanenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                r'PERKIRAAN WAKTU PANEN',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
              ),
              const Divider(),
              width > 475
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Panen(node: r'node1'),
                        Panen(node: r'node2'),
                      ],
                    )
                  : const Column(
                      children: [
                        Panen(node: r'node1'),
                        Panen(node: r'node2'),
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
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      )),
                      TableCell(
                          child: Text(
                        r'PPM',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      )),
                      TableCell(
                          child: Text(
                        r'WAKTU PANEN',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ))
                    ],
                  ),
                  for (var tanaman in Tanaman.values)
                    TableRow(
                      children: [
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(tanaman.nama.toCapitalize(),
                                style: const TextStyle(fontSize: 20)),
                          ),
                        ),
                        TableCell(
                            child: Text('${tanaman.ppmMin} - ${tanaman.ppmMax}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 20))),
                        TableCell(
                            child: Text(
                                '${tanaman.panen1} - ${tanaman.panen2} hari',
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 20)))
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
