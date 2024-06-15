import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

FirebaseMessaging messaging = FirebaseMessaging.instance;

void initializeFirebaseMessaging() async {
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

 // Обработка уведомлений, полученных во время активного использования приложения
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Received message in foreground: ${message.notification?.title}');
  // Здесь можно добавить логику для обработки уведомления во фронтэнде
  });


  // Обработка случая, когда пользователь тапает на уведомление и приложение открыто
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('User tapped notification: ${message.notification?.title}');
 
    navigatorKey.currentState?.pushNamed('/notification_screen', arguments: message);
  });

  // Request permission for iOS devices
  // NotificationSettings settings = await messaging.requestPermission(
  //   alert: true,
  //   badge: true,
  //   sound: true,
  // );
  // print('User granted permission: ${settings.authorizationStatus}');

  String? token = await messaging.getToken();
  print('FCM token: $token');
}

// Background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message: ${message.notification?.title}');
  // Handle your background message here
}
