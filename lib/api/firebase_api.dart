import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:go_router/go_router.dart';

import '../main.dart';

class FirebaseApi {
  // create an instance of Firebase Messaging
  final _firebaseMessaging = FirebaseMessaging.instance;

  // function to initialize notifications
  Future<void> initNotifications() async {
    // request permission from user (will prompt user)
    await _firebaseMessaging.requestPermission();

    // fetch the FCM token for this device
    // final fCMToken = await _firebaseMessaging.getToken(
    //     vapidKey:
    //         "BILVoci9JBvn6yPgYuUmvHlI_vDln5k4Uw05vPJYscVKXJj9TH3nd401809Mx_CE5MVotfy9VHrLW-Fyn3kQ-Zc");
    final fcmToken = await _firebaseMessaging.getToken();

    // print the token
    print('Token: $fcmToken');

    // initialize further settings for push notification
    initPushNotifications();
  }

  // function to handle received messages
  void handleMessage(RemoteMessage? message) {
    // if the message is null, do nothing
    if (message == null) return;

    // navigate to new screen when message is received and user taps notification
    navigatorKey.currentContext?.go('/');
  }

  // function to handle background messages
  Future<void> backgroundHandler(RemoteMessage? message) async {
    if (message == null) return;
    print(message.data);
  }

  // function to initialize foreground and background settings
  Future initPushNotifications() async {
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  }
}
