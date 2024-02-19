class NutrisiData {
  int? interval;
  DateTime? lastAdded;

  NutrisiData.fromJson(Map<String, dynamic> json) {
    interval = json['interval'];
    lastAdded = DateTime.parse(json['lastAdded']);
  }
}
