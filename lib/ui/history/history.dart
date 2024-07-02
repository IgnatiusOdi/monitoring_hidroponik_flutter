import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../repository/firestore_repository.dart';

class History extends StatelessWidget {
  final String node;
  final FirestoreRepository repository;

  const History({super.key, required this.node, required this.repository});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: repository.getNode(node),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
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
                  pathParameters: {'node': node, 'docid': doc.id},
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
