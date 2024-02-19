class StatusData {
  double? status;

  StatusData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
  }
}
