import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/tanaman.dart';
import '../../repository/realtimedb_repository.dart';
import 'panen.dart';

class PanenScreen extends StatelessWidget {
  const PanenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final repository = RepositoryProvider.of<RealtimedbRepository>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
                      Panen(node: r'node1', repository: repository),
                      Panen(node: r'node2', repository: repository),
                    ],
                  )
                : Column(
                    children: [
                      Panen(node: r'node1', repository: repository),
                      Panen(node: r'node2', repository: repository),
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
