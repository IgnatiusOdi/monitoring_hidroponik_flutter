import 'tanaman.dart';

class Data {
  DateTime? penambahanPPM;
  double? ph;
  int? ppm;
  bool? status;
  double? suhu;
  TanamanData? tanaman;
  int? tinggiAir;

  Data.fromJson(Map<dynamic, dynamic> json) {
    penambahanPPM = DateTime.parse(json['penambahanPPM']);
    ph = json['ph'];
    ppm = json['ppm'];
    status = json['status'];
    suhu = json['suhu'];
    tanaman = TanamanData.fromJson(json['tanaman']);
    tinggiAir = json['tinggiAir'];
  }
}
