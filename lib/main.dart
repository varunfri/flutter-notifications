// import 'package:notification_flutter/api/firebase_api.dart';
// import 'package:notification_flutter/firebase_options.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'export/export.dart';
// import 'package:permission_handler/permission_handler.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   tz.initializeTimeZones();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

//   // await FirebaseApi().initFirebase();
//   if (await Permission.notification.isDenied) {
//     await Permission.notification.request();
//   }
//   if (await Permission.photos.isDenied) {
//     await Permission.photos.request();
//   }
//   if (await Permission.scheduleExactAlarm.isDenied) {
//     await Permission.scheduleExactAlarm.request();
//   }
//   final notification = NotificationService();

//   await notification.initializeNotification();
//   runApp(const MyApp());
// }

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

final FlutterLocalNotificationsPlugin localNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize timezone
  tz.initializeTimeZones();

  // Initialize notifications
  const AndroidInitializationSettings androidInitSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const DarwinInitializationSettings iosInitSettings =
      DarwinInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
      );

  const InitializationSettings initSettings = InitializationSettings(
    android: androidInitSettings,
    iOS: iosInitSettings,
  );

  await localNotificationsPlugin.initialize(initSettings);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: Home());
  }
}

Future<void> requestNotificationPermission() async {
  // Android 13+
  await Permission.notification.request();

  // iOS handled in initialization (already requested)
}

Future<void> scheduleDailyNotification({
  required int id,
  required String title,
  required String body,
  required int hour,
  required int minute,
}) async {
  final now = tz.TZDateTime.now(tz.local);

  // Set scheduled time
  var scheduledDate = tz.TZDateTime(
    tz.local,
    now.year,
    now.month,
    now.day,
    hour,
    minute,
  );

  // If the time is already passed today, schedule for tomorrow
  if (scheduledDate.isBefore(now)) {
    scheduledDate = scheduledDate.add(const Duration(days: 1));
  }

  // Notification details
  const androidDetails = AndroidNotificationDetails(
    'daily_channel_id',
    'Daily Notifications',
    channelDescription: 'Daily notification channel',
    importance: Importance.max,
    priority: Priority.high,
  );

  const iosDetails = DarwinNotificationDetails();

  const notificationDetails = NotificationDetails(
    android: androidDetails,
    iOS: iosDetails,
  );

  // Schedule notification
  await localNotificationsPlugin.zonedSchedule(
    id,
    title,
    body,
    scheduledDate,
    notificationDetails,
    androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    matchDateTimeComponents:
        DateTimeComponents.time, // repeats daily at same time
  );

  debugPrint("Notification scheduled at $scheduledDate");
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () async {
              await requestNotificationPermission();

              await scheduleDailyNotification(
                id: 1,
                title: "Punch In",
                body: "Don't forget to punch in!",
                hour: 23,
                minute: 25,
              );
            },
            child: Text("Schedule Daily Notification"),
          ),
        ],
      ),
    );
  }
}
