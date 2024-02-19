class PanenData {
  DateTime? harvest1;
  DateTime? harvest2;
  DateTime? start;
  String? tanaman;

  PanenData.fromJson(Map<String, dynamic> json) {
    harvest1 = DateTime.parse(json['harvest1']);
    harvest2 = DateTime.parse(json['harvest2']);
    start = DateTime.parse(json['start']);
    tanaman = json['tanaman'];
  }

  @override
  String toString() {
    return '{harvest1: $harvest1, harvest2: $harvest2, start: $start, tanaman: $tanaman}';
  }
}
