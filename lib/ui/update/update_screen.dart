import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/data.dart';
import '../../models/tanaman.dart';
import '../../repository/firestore_repository.dart';
import '../../repository/realtimedb_repository.dart';

enum Node { node1, node2 }

class UpdateScreen extends StatefulWidget {
  const UpdateScreen({super.key});

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  late FirestoreRepository firestoreRepository;
  late RealtimedbRepository realtimedbRepository;

  String? node;
  Tanaman? selectedTanaman;
  bool loading = false, error = false, success = false;

  @override
  void initState() {
    firestoreRepository = context.read<FirestoreRepository>();
    realtimedbRepository = context.read<RealtimedbRepository>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          const Text('UPDATE TANAMAN',
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
                ListView(
                  shrinkWrap: true,
                  children: Node.values
                      .map((n) => ListTile(
                          title: Text(n.name),
                          selected: node == n.name,
                          selectedColor: Colors.white,
                          selectedTileColor: theme.primaryColor,
                          onTap: () {
                            setState(() {
                              node = n.name;
                            });
                          }))
                      .toList(),
                )
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
              ? const Text("Mohon mengisi node dan tanaman",
                  style: TextStyle(color: Colors.red))
              : Container(),
          success
              ? Text("Berhasil update $node",
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

                    var data = await realtimedbRepository.getFutureNode(node!);

                    // Add to Cloud Firestore
                    firestoreRepository.addLog(
                      node!,
                      Data.fromJson(
                          data.snapshot.value as Map<dynamic, dynamic>),
                    );

                    // Update Tanaman
                    await realtimedbRepository
                        .updateTanaman(node!, selectedTanaman!)
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
