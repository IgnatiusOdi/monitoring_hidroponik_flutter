import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/widgets.dart';

import '../models/tanaman.dart';

class RealtimeDatabaseService {
  final _databaseService = FirebaseDatabase.instance;

  Stream<DatabaseEvent> getNode(String node) {
    return _databaseService.ref(node).onValue;
  }

  Future<void> updateTanaman(String node, Tanaman tanaman) async {
    await _databaseService.ref(node).update({
      'jenis':
          '${tanaman.nama.characters.first.toUpperCase()}${tanaman.nama.characters.skip(1)}',
      'mulai': DateTime.now().toString().split(' ').first,
      'panen1': DateTime.now()
          .add(Duration(days: tanaman.panen1))
          .toString()
          .split(' ')
          .first,
      'panen2': DateTime.now()
          .add(Duration(days: tanaman.panen2))
          .toString()
          .split(' ')
          .first,
      'ppmMax': tanaman.ppmMax,
      'ppmMin': tanaman.ppmMin,
    });
  }
}
