import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:push_noti/api/firebase_api.dart';
import 'package:push_noti/firebase_options.dart';
import 'package:push_noti/pages/firebase_messaging.dart';
import 'package:push_noti/pages/home_page.dart';
import 'package:push_noti/pages/notification_page.dart';
import 'package:push_noti/pages/saved_notifications_screen.dart'; 

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseApi().initNotifications();

  runApp(const MyApp());
  initializeFirebaseMessaging();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      routes: {
        '/notification_screen': (context) => NotificationPage(),
        '/saved_notifications': (context) => SavedNotificationsScreen(), 
      },
    );
  }
}
