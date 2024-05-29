class GraphData {
  DateTime? tanggal;
  String? value;

  GraphData(this.tanggal, this.value);

  GraphData.fromJson(Map<dynamic, dynamic> json) {
    tanggal = DateTime.parse(json['tanggal']);
    value = json['value'];
  }

  @override
  String toString() {
    return 'tanggal: $tanggal, value: $value';
  }
}
