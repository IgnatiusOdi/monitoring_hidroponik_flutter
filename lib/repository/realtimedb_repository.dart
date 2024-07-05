import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

import '../models/tanaman.dart';
import '../utils/date_utils.dart';
import '../utils/string_utils.dart';

class RealtimedbRepository {
  final _database = FirebaseDatabase.instance;

  Stream<DatabaseEvent> getStreamNode(String node) {
    return _database.ref(node).orderByKey().onValue;
  }

  Future<DatabaseEvent> getFutureNode(String node) async {
    return await _database.ref(node).orderByKey().once();
  }

  Future<void> updateTanaman(String node, Tanaman tanaman) async {
    try {
      final now = DateTime.now();
      final date = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
      await _database.ref('$node/data').set({date: "0.00,0,0.00"});

      await _database.ref('$node/tanaman').update({
        'jenis': tanaman.nama.toCapitalize(),
        'mulai': now.toDateString(),
        'panen1': now.add(Duration(days: tanaman.panen1)).toDateString(),
        'panen2': now.add(Duration(days: tanaman.panen2)).toDateString(),
        'ppmMax': tanaman.ppmMax,
        'ppmMin': tanaman.ppmMin,
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
