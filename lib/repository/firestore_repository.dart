import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:monitoring_hidroponik_flutter/models/data.dart';

class FirestoreRepository {
  final _firestore = FirebaseFirestore.instance;

  Future<QuerySnapshot> getFutureNode(String node) {
    return _firestore.collection(node).orderBy('tanggal').get();
  }

  Future<QuerySnapshot> getFutureHistory(
      String node, String docid, String tanggal) {
    return _firestore.collection(node).doc(docid).collection(tanggal).get();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getHistory(
      String node, String docid, String tanggal) {
    return _firestore
        .collection(node)
        .doc(docid)
        .collection(tanggal)
        .snapshots();
  }

  Future<void> addLog(String node, Data data) async {
    try {
      var doc = await _firestore.collection(node).add({
        'tanaman': data.tanaman!.jenis,
        'tanggal': DateFormat('yyyy-MM-dd').format(data.tanaman!.mulai!),
      });

      for (var e in data.data!) {
        await _firestore
            .collection(node)
            .doc(doc.id)
            .collection(DateFormat('yyyy-MM-dd').format(data.tanaman!.mulai!))
            .add({'${e.tanggal}': e.value});
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
