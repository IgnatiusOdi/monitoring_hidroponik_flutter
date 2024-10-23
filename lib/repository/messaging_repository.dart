import 'package:firebase_messaging/firebase_messaging.dart';

class MessagingRepository {
  final _firebaseMessaging =
      FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    await _firebaseMessaging
        .subscribeToTopic("hidroponik-flutter");
  }
}
