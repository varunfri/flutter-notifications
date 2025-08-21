import 'package:notification_flutter/export/export.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  NotificationService().showNotification(
    title: message.toString(),
    body: "",
  ); // Call local notification here if needed
}

class FirebaseApi {
  // initialize the firebase messagning

  final _firebaseMessagning = FirebaseMessaging.instance;

  // init the instance
  Future<void> initFirebase() async {
    // request permissions from user
    await _firebaseMessagning.requestPermission();

    final token = await _firebaseMessagning.getToken();

    debugPrint("Token : $token");

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // fireground message

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      NotificationService().showNotification(
        title: message.notification?.title ?? "No Title",
        body: message.notification?.body ?? "No body",
      );
    });
  }
}
