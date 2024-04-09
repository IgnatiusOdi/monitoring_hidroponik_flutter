import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../model/tanaman.dart';

enum Node { node1, node2 }

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  String? node;
  Tanaman? selectedTanaman;
  bool loading = false;
  bool error = false;
  bool success = false;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Tambah Tanaman Baru',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const Divider(),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Node :', style: TextStyle(fontSize: 24)),
                  Row(
                    children: [
                      Radio(
                        value: Node.node1.name,
                        groupValue: node,
                        onChanged: (value) {
                          setState(() {
                            node = value;
                          });
                        },
                      ),
                      Text(Node.node1.name),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: Node.node2.name,
                        groupValue: node,
                        onChanged: (value) {
                          setState(() {
                            node = value;
                          });
                        },
                      ),
                      Text(Node.node2.name),
                    ],
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Tanaman :', style: TextStyle(fontSize: 24)),
                  ListView(
                    shrinkWrap: true,
                    children: Tanaman.values
                        .map(
                          (tanaman) => ListTile(
                            title: Text(
                                '${tanaman.nama.characters.first.toUpperCase()}${tanaman.nama.characters.skip(1)}'),
                            onTap: () {
                              setState(() {
                                selectedTanaman = tanaman;
                              });
                            },
                            selected: selectedTanaman == tanaman,
                            selectedColor: Colors.white,
                            selectedTileColor: theme.primaryColor,
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
            error
                ? const Text("Mohon mengisi node dan tanaman",
                    style: TextStyle(color: Colors.red))
                : Container(),
            success
                ? Text("Berhasil menambah tanaman baru",
                    style: TextStyle(color: theme.primaryColor))
                : Container(),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () async {
                  if (node == null || selectedTanaman == null) {
                    setState(() {
                      error = true;
                    });
                  } else {
                    setState(() {
                      loading = true;
                      error = false;
                    });
                    final ref = FirebaseDatabase.instance.ref('$node/tanaman');
                    await ref.update({
                      'jenis':
                          '${selectedTanaman!.nama.characters.first.toUpperCase()}${selectedTanaman!.nama.characters.skip(1)}',
                      'mulai': DateTime.now().toString().split(' ').first,
                      'panen1': DateTime.now()
                          .add(Duration(days: selectedTanaman!.panen1))
                          .toString()
                          .split(' ')
                          .first,
                      'panen2': DateTime.now()
                          .add(Duration(days: selectedTanaman!.panen2))
                          .toString()
                          .split(' ')
                          .first,
                      'ppmMax': selectedTanaman!.ppmMax,
                      'ppmMin': selectedTanaman!.ppmMin,
                    }).then((value) {
                      setState(() {
                        loading = false;
                        success = true;
                      });
                      debugPrint('Sukses menambah tanaman baru');
                    });
                  }
                },
                child: loading
                    ? const CircularProgressIndicator()
                    : const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
