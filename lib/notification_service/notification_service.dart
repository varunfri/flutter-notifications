import 'package:notification_flutter/export/export.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  //creating an instance
  final FlutterLocalNotificationsPlugin localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  //initializationFunction
  Future<void> initializeNotification() async {
    if (_isInitialized) return;

    tz.initializeTimeZones();
    final currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone.identifier));

    //
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

  Future<void> scheduleNotification({
    int id = 1,
    required String title,
    required String body,
    required int hour,
    required int minutes,
  }) async {
    final now = tz.TZDateTime.now(tz.local);

    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minutes,
    );

    final androidDetails = AndroidNotificationDetails(
      'daily_reminder_channel_id', // channelId
      'Daily Reminders', // channelName (user visible)
      channelDescription: 'Channel for daily reminder notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    final iosDetails = DarwinNotificationDetails();

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await localNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    debugPrint("Scheduled Reminder");
  }

  Future<void> cancelAllNotifications() async {
    await localNotificationsPlugin.cancelAll();
  }
}
