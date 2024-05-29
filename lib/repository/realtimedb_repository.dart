import 'package:firebase_database/firebase_database.dart';

import '../models/tanaman.dart';
import '../utils/date_utils.dart';
import '../utils/string_utils.dart';

class RealtimedbRepository {
  final _database = FirebaseDatabase.instance;

  Stream<DatabaseEvent> getNode(String node) {
    return _database.ref(node).orderByKey().onValue;
  }

  Future<void> updateTanaman(String node, Tanaman tanaman) async {
    await _database.ref(node).update({
      'jenis': tanaman.nama.toCapitalize(),
      'mulai': DateTime.now().toDateString(),
      'panen1':
          DateTime.now().add(Duration(days: tanaman.panen1)).toDateString(),
      'panen2':
          DateTime.now().add(Duration(days: tanaman.panen2)).toDateString(),
      'ppmMax': tanaman.ppmMax,
      'ppmMin': tanaman.ppmMin,
    });
  }
}
