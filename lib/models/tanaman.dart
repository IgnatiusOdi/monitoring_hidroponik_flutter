enum Tanaman { selada, kemangi }

class TanamanData {
  int? interval;
  String? jenis;
  DateTime? mulai;
  DateTime? panen1;
  DateTime? panen2;
  int? ppmMax;
  int? ppmMin;

  TanamanData.fromJson(Map<dynamic, dynamic> json) {
    interval = json['interval'];
    jenis = json['jenis'];
    mulai = DateTime.parse(json['mulai']);
    panen1 = DateTime.parse(json['panen1']);
    panen2 = DateTime.parse(json['panen2']);
    ppmMax = json['ppmMax'];
    ppmMin = json['ppmMin'];
  }

  @override
  String toString() {
    return '{interval: $interval, jenis: $jenis, mulai: $mulai, panen1: $panen1, panen2: $panen2, ppmMax: $ppmMax, ppmMin: $ppmMin}';
  }
}

extension TanamanExtension on Tanaman {
  String get nama => name;

  int get panen1 {
    switch (this) {
      case Tanaman.selada:
        return 30;
      case Tanaman.kemangi:
        return 120;
    }
  }

  int get panen2 {
    switch (this) {
      case Tanaman.selada:
        return 40;
      case Tanaman.kemangi:
        return 150;
    }
  }

  int get ppmMax {
    switch (this) {
      case Tanaman.selada:
        return 840;
      default:
        return 1120;
    }
  }

  int get ppmMin {
    switch (this) {
      case Tanaman.selada:
        return 560;
      default:
        return 700;
    }
  }
}
