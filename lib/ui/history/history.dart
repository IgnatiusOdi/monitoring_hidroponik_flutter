import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:monitoring_hidroponik_flutter/repository/firestore_repository.dart';

class History extends StatefulWidget {
  final String node;

  const History({super.key, required this.node});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> stream;

  @override
  initState() {
    stream = context.read<FirestoreRepository>().getNode(widget.node);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData) {
          return const Center(child: Text('No data'));
        }

        var data = snapshot.data!.docs.map((e) => e.data()).toList();
        data.sort((a, b) => a['tanggal'].compareTo(b['tanggal']));

        if (data.isEmpty) {
          return const Text(
            'Tidak ada history',
            style: TextStyle(fontSize: 18),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var doc = snapshot.data!.docs[index];

            return ListTile(
              title: Row(
                children: [
                  Text('${doc.data()['tanaman']} - ${doc.data()['tanggal']}'),
                  const Spacer(),
                  const Icon(Icons.arrow_forward),
                ],
              ),
              onTap: () {
                context.goNamed(
                  'detail',
                  pathParameters: {'node': widget.node, 'docid': doc.id},
                  extra: doc.data()['tanggal'],
                );
              },
            );
          },
        );
      },
    );
  }
}
