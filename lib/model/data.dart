import 'nutrisi_data.dart';
import 'panen_data.dart';
import 'status_data.dart';

class Data {
  NutrisiData? nutrisi;
  PanenData? panen;
  StatusData? ph;
  StatusData? ppm;
  bool? status;
  StatusData? suhu;

  Data.fromJson(Map<String, dynamic> json) {
    nutrisi = NutrisiData.fromJson(json['nutrisi']);
    panen = PanenData.fromJson(json['panen']);
    ph = StatusData.fromJson(json['ph']);
    ppm = StatusData.fromJson(json['ppm']);
    status = json['status'];
    suhu = StatusData.fromJson(json['suhu']);
  }
}
