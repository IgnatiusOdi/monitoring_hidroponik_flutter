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
  List<QueryDocumentSnapshot>? docs;

  void getData() async {
    await context
        .read<FirestoreRepository>()
        .getFutureNode(widget.node)
        .then((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        setState(() {
          docs = snapshot.docs;
        });
      }
    });
  }

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return docs != null
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: docs!.length,
            itemBuilder: (context, index) {
              final doc = docs![index];

              return ListTile(
                title: Row(
                  children: [
                    Text('${doc['tanaman']} - ${doc['tanggal']}'),
                    const Spacer(),
                    const Icon(Icons.arrow_forward),
                  ],
                ),
                onTap: () {
                  context.goNamed(
                    'detail',
                    pathParameters: {'node': widget.node, 'docid': doc.id},
                    extra: doc['tanggal'],
                  );
                },
              );
            },
          )
        : const Text(
            'Tidak ada history',
            style: TextStyle(fontSize: 18),
          );
  }
}
