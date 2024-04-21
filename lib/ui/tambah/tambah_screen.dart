import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/realtime_database_service.dart';
import '../../models/tanaman.dart';

enum Node { node1, node2 }

class TambahScreen extends StatefulWidget {
  const TambahScreen({super.key});

  @override
  State<TambahScreen> createState() => _TambahScreenState();
}

class _TambahScreenState extends State<TambahScreen> {
  String? node;
  Tanaman? selectedTanaman;
  bool loading = false, error = false, success = false;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final service =
        Provider.of<RealtimeDatabaseService>(context, listen: false);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          const Text('Tambah Tanaman Baru',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const Divider(),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                border: Border.all(), borderRadius: BorderRadius.circular(8)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Node :', style: TextStyle(fontSize: 24)),
                Row(children: [
                  Radio(
                      value: Node.node1.name,
                      groupValue: node,
                      onChanged: (value) {
                        setState(() {
                          node = value;
                        });
                      }),
                  Text(Node.node1.name)
                ]),
                Row(children: [
                  Radio(
                      value: Node.node2.name,
                      groupValue: node,
                      onChanged: (value) {
                        setState(() {
                          node = value;
                        });
                      }),
                  Text(Node.node2.name)
                ])
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                border: Border.all(), borderRadius: BorderRadius.circular(8)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Tanaman :', style: TextStyle(fontSize: 24)),
                ListView(
                  shrinkWrap: true,
                  children: Tanaman.values
                      .map((tanaman) => ListTile(
                          title: Text(
                              '${tanaman.nama.characters.first.toUpperCase()}${tanaman.nama.characters.skip(1)}'),
                          selected: selectedTanaman == tanaman,
                          selectedColor: Colors.white,
                          selectedTileColor: theme.primaryColor,
                          onTap: () {
                            setState(() {
                              selectedTanaman = tanaman;
                            });
                          }))
                      .toList(),
                )
              ],
            ),
          ),
          error
              ? const Text("Mohon mengisi node dan node",
                  style: TextStyle(color: Colors.red))
              : Container(),
          success
              ? Text("Berhasil menambah node baru",
                  style: TextStyle(color: theme.primaryColor))
              : Container(),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
                onPressed: () async {
                  if (node == null || selectedTanaman == null) {
                    setState(() => error = true);
                  } else {
                    setState(() {
                      loading = true;
                      error = false;
                    });
                    await service
                        .updateTanaman('$node/tanaman', selectedTanaman!)
                        .then((_) => setState(() {
                              loading = false;
                              success = true;
                            }));
                  }
                },
                child: loading
                    ? const CircularProgressIndicator()
                    : const Text('Save')),
          )
        ]),
      ),
    );
  }
}
