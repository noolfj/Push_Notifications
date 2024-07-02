import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'notification_storage.dart'; 

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

FirebaseMessaging messaging = FirebaseMessaging.instance;

void initializeFirebaseMessaging() async {
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Получено сообщение в активном режиме: ${message.notification?.title}');
    _saveNotification(message.notification!.title ?? '', message.notification!.body ?? '', message.sentTime.toString());
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('Пользователь тапнул по уведомлению: ${message.notification?.title}');
    _saveNotification(message.notification!.title ?? '', message.notification!.body ?? '', message.sentTime.toString());
    navigatorKey.currentState?.pushNamed('/notification_screen', arguments: message);
  });

  String? token = await messaging.getToken();
  print('FCM token: $token');
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Обработка фонового сообщения: ${message.notification?.title}');
  await NotificationStorage().saveNotification(
    message.notification?.title ?? '',
    message.notification?.body ?? '',
    message.sentTime.toString(),
  );
}

void _saveNotification(String title, String body, String dateTime) async {
  await NotificationStorage().saveNotification(title, body, dateTime);
}
