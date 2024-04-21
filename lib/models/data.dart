import 'graph_data.dart';
import 'tanaman.dart';

class Data {
  int? command;
  List<GraphData>? data;
  DateTime? penambahanPPM;
  num? ph;
  int? ppm;
  bool? status;
  num? suhu;
  TanamanData? tanaman;
  int? tinggiAir;

  Data.fromJson(Map<dynamic, dynamic> json) {
    command = json['command'];
    data = (json['data'] as Map<dynamic, dynamic>)
        .entries
        .map((e) => GraphData(DateTime.parse(e.key), e.value))
        .toList();
    penambahanPPM = DateTime.parse(json['penambahanPPM']);
    ph = json['ph'];
    ppm = json['ppm'];
    status = json['status'];
    suhu = json['suhu'];
    tanaman = TanamanData.fromJson(json['tanaman']);
    tinggiAir = json['tinggiAir'];
  }
}
