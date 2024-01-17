import 'package:flutter/material.dart';

class PanenView extends StatelessWidget {
  const PanenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Perkiraan Waktu Panen',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
            const Text('SELADA',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32)),
            const Text('34 hari lagi',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
            Table(
              border: TableBorder.all(),
              children: const [
                TableRow(
                  children: [
                    TableCell(
                        child: Text('TANAMAN',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20))),
                    TableCell(
                        child: Text('PPM',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20))),
                    TableCell(
                        child: Text('WAKTU PANEN',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20)))
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                        child: Text('Selada', style: TextStyle(fontSize: 20))),
                    TableCell(
                        child: Text('560 - 840',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20))),
                    TableCell(
                        child: Text('30 - 40 hari',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20)))
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                        child: Text('Kangkung', style: TextStyle(fontSize: 20))),
                    TableCell(
                        child: Text('1050 - 1400',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20))),
                    TableCell(
                        child: Text('21 - 25 hari',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20)))
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                        child: Text('Sawi', style: TextStyle(fontSize: 20))),
                    TableCell(
                        child: Text('1050 - 1400',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20))),
                    TableCell(
                        child: Text('25 - 30 hari',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20)))
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                        child: Text('Pakcoy', style: TextStyle(fontSize: 20))),
                    TableCell(
                        child: Text('1050 - 1400',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20))),
                    TableCell(
                        child: Text('40 - 45 hari',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20)))
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
