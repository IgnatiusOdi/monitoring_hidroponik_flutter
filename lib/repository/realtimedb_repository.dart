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

  Future<DatabaseEvent> getFutureNode(String node) {
    return _database.ref(node).orderByKey().once();
  }

  Future<void> updateTanaman(String node, Tanaman tanaman) async {
    try {
      await _database.ref('$node/data').set({
        DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()): "0.00,0,0.00"
      });
      await _database.ref('$node/tanaman').update({
        'jenis': tanaman.nama.toCapitalize(),
        'mulai': DateTime.now().toDateString(),
        'panen1':
            DateTime.now().add(Duration(days: tanaman.panen1)).toDateString(),
        'panen2':
            DateTime.now().add(Duration(days: tanaman.panen2)).toDateString(),
        'ppmMax': tanaman.ppmMax,
        'ppmMin': tanaman.ppmMin,
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
