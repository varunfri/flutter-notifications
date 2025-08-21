import 'package:notification_flutter/export/export.dart';

class NotificationService {
  //creating an instance
  final FlutterLocalNotificationsPlugin localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  //initializationFunction
  Future<void> initializeNotification() async {
    const AndroidInitializationSettings androidInitSettings =
        AndroidInitializationSettings("@mipmap/ic_launcher");

    const InitializationSettings initSettings = InitializationSettings(
      android: androidInitSettings,
    );

    await localNotificationsPlugin.initialize(initSettings);
  }

  Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          "approval_channel",
          "Approvals Channel",
          importance: Importance.max,
          priority: Priority.high,
        );

    // register the createdDetails

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await localNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      notificationDetails,
    );
  }
}
