import 'dart:async';

import "package:intl/intl.dart";
import 'package:notification_flutter/export/export.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final notify = NotificationService();
  @override
  void initState() {
    super.initState();
    startTimeCheck();
  }

  void startTimeCheck() {
    Timer.periodic(Duration(seconds: 30), (timer) {
      debugPrint("Time ${timer.tick}:");
      final time = DateFormat("h:mm a").format(DateTime.now());
      if (time.toLowerCase() == "10:12 pm") {
        debugPrint("Notified!!");
        notify.showNotification(
          title: "Time is: $time",
          body: "Time to notify",
        );
      }
    });
  }

  void schedule() async {
    debugPrint("Started");
    await notify.scheduleNotification(
      title: "Punch in",
      body: "ASD",
      hour: 22,
      minutes: 55,
    );

    debugPrint("NOtified!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            debugPrint("scheduluing the schedule");
            // await notify.showNotification(title: "title", body: "body");
            // startTimeCheck();
            schedule();
          },
          child: Text("Show Notification"),
        ),
      ),
    );
  }
}
