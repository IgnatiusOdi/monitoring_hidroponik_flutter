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
  State<UpdateScreen> createState() =>
      _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  String? node;
  Tanaman? selectedTanaman;
  bool loading = false;
  bool error = false;
  bool success = false;
  String message = "";

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          const Text('UPDATE TANAMAN',
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold)),
          const Divider(),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                border: Border.all(),
                borderRadius:
                    BorderRadius.circular(8)),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text('Node :',
                    style: TextStyle(fontSize: 24)),
                ListView(
                  shrinkWrap: true,
                  children: Node.values
                      .map((n) => ListTile(
                          title: Text(n.name),
                          selected: node == n.name,
                          selectedColor: Colors.white,
                          selectedTileColor:
                              theme.primaryColor,
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
            margin: const EdgeInsets.symmetric(
                vertical: 8.0),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                border: Border.all(),
                borderRadius:
                    BorderRadius.circular(8)),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text('Tanaman :',
                    style: TextStyle(fontSize: 24)),
                ListView(
                  shrinkWrap: true,
                  children: Tanaman.values
                      .map((tanaman) => ListTile(
                          title: Text(
                              '${tanaman.nama.characters.first.toUpperCase()}${tanaman.nama.characters.skip(1)}'),
                          selected: selectedTanaman ==
                              tanaman,
                          selectedColor: Colors.white,
                          selectedTileColor:
                              theme.primaryColor,
                          onTap: () {
                            setState(() {
                              selectedTanaman =
                                  tanaman;
                            });
                          }))
                      .toList(),
                )
              ],
            ),
          ),
          error || success
              ? Text(message,
                  style: TextStyle(
                      color: error
                          ? Colors.red
                          : theme.primaryColor))
              : Container(),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
                onPressed: () async {
                  if (!mounted) return;
                  setState(() {
                    loading = true;
                    error = false;
                    success = false;
                  });
                  if (node == null ||
                      selectedTanaman == null) {
                    setState(() {
                      error = true;
                      message =
                          "Mohon mengisi node dan tanaman";
                    });
                  } else {
                    try {
                      var data = await context
                          .read<RealtimedbRepository>()
                          .getFutureNode(node!);
                      // Add to Cloud Firestore
                      await context
                          .read<FirestoreRepository>()
                          .addLog(
                              node!,
                              Data.fromJson(
                                  data.snapshot.value
                                      as Map<dynamic,
                                          dynamic>));
                      // Update Tanaman
                      await context
                          .read<RealtimedbRepository>()
                          .updateTanaman(
                              node!, selectedTanaman!)
                          .then((_) {
                        setState(() {
                          loading = false;
                          success = true;
                          message =
                              "Berhasil update $node";
                        });
                      });
                    } catch (e) {
                      setState(() {
                        loading = false;
                        error = true;
                        message = e.toString();
                      });
                    }
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
