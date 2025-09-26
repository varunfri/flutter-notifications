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
      if (time.toLowerCase() == "10:19 pm") {
        notify.showNotification(
          title: "Time is: $time",
          body: "Time to notify",
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            debugPrint("scheduluing the schedule");
            await NotificationService().scheduleNotification(
              title: "Alarm",
              body: "ASDFASDF",
              hour: 19,
              minutes: 10,
            );
          },
          child: Text("Show Notification"),
        ),
      ),
    );
  }
}
