import 'package:notification_flutter/api/firebase_api.dart';
import 'package:notification_flutter/firebase_options.dart';

import 'export/export.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await FirebaseApi().initFirebase();
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }
  if (await Permission.photos.isDenied) {
    await Permission.photos.request();
  }
  final notification = NotificationService();

  await notification.initializeNotification();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: Home());
  }
}
