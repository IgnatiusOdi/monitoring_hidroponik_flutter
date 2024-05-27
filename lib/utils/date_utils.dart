extension DateTimeExtension on DateTime {
  String toDateString() {
    return toString().split(' ').first;
  }
}
