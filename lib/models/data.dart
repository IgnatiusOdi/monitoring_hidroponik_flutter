import 'graph_data.dart';
import 'tanaman.dart';

class Data {
  List<GraphData>? data;
  DateTime? penambahanPPM;
  TanamanData? tanaman;
  int? tinggiAir;

  Data.fromJson(Map<dynamic, dynamic> json) {
    data = (json['data'] as Map<dynamic, dynamic>)
        .entries
        .map((e) =>
            GraphData(DateTime.parse(e.key), e.value))
        .toList();
    penambahanPPM =
        DateTime.parse(json['penambahanPPM']);
    tanaman = TanamanData.fromJson(json['tanaman']);
    tinggiAir = json['tinggiAir'];
  }
}
