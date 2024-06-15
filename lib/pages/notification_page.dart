import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart'; 
import 'notification_storage.dart'; 
import 'saved_notifications_screen.dart'; 

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final NotificationStorage _notificationStorage = NotificationStorage();
  bool _isNotificationSaved = false;

  @override
  Widget build(BuildContext context) {
    final message = ModalRoute.of(context)!.settings.arguments as RemoteMessage;

    String? imageUrl = message.notification?.android?.imageUrl ?? message.data['image'];
    String dateTime = DateFormat('yyyy-MM-dd – kk:mm').format(message.sentTime ?? DateTime.now());

    // Save notification only once when the page is first built
    if (!_isNotificationSaved) {
      _saveNotification(message.notification!.title ?? '', message.notification!.body ?? '', dateTime);
      _isNotificationSaved = true;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Уведомления",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xff025097),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Card(
            color: Colors.white, // Устанавливаем белый цвет заднего фона у Card
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(color: Color(0xff025097), width: 1),
            ),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (imageUrl != null)
                    Container(
                      width: double.infinity,
                      height: 350,
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.contain,
                        placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
                      ),
                    ),
                  SizedBox(height: imageUrl != null ? 16 : 0),
                  Text(
                    message.notification!.title ?? '',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff025097),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    message.notification!.body ?? '',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  Text(
                    dateTime,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SavedNotificationsScreen()),
          );
        },
        child: Icon(Icons.history),
        backgroundColor: Color(0xffDF9B25),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, 
    );
  }

  Future<void> _saveNotification(String title, String body, String dateTime) async {
    await _notificationStorage.saveNotification(title, body, dateTime);
  }
}


// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:permission_handler/permission_handler.dart';


// class NotificationPage extends StatelessWidget {
//   const NotificationPage({Key? key});

//   Future<void> saveDataToFile(String title, String body, String? imageUrl) async {
//     // Получаем директорию для сохранения файла
//     Directory? directory = await getExternalStorageDirectory(); // Внешнее хранилище

//     // Если внешнее хранилище недоступно, используем внутреннее
//     if (directory == null) {
//       directory = await getApplicationDocumentsDirectory(); // Внутреннее хранилище
//     }

//     String filePath = '${directory.path}/notification_data.txt';

//     // Создаем содержимое для сохранения в файле
//     String content = 'Title: $title\nBody: $body\n';
//     if (imageUrl != null) {
//       content += 'Image URL: $imageUrl';
//     }

//     // Записываем данные в файл
//     await File(filePath).writeAsString(content);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final message = ModalRoute.of(context)!.settings.arguments as RemoteMessage;

//     String? imageUrl = message.notification?.android?.imageUrl ?? message.data['image'];

//     return Scaffold(
//       appBar: AppBar(title: const Text("Уведомления")),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           if (imageUrl != null)
//             CachedNetworkImage(
//               imageUrl: imageUrl!,
//               width: 200,
//               height: 200,
//               placeholder: (context, url) => CircularProgressIndicator(),
//               errorWidget: (context, url, error) => Icon(Icons.error),
//             ),

//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Text(
//                   message.notification!.title ?? '',
//                   style: TextStyle(
//                     fontSize: 30,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.blue,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 SizedBox(height: 8),
//                 Text(
//                   message.notification!.body ?? '',
//                   style: TextStyle(
//                     fontSize: 18,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 SizedBox(height: 16),
//           ElevatedButton(
//                   onPressed: () async {
//                     var status = await Permission.storage.request();
//                     if (status.isGranted) {
//                       // Разрешение получено, можно сохранять файл
//                       saveDataToFile(
//                         message.notification!.title ?? '',
//                         message.notification!.body ?? '',
//                         imageUrl,
//                       ).then((_) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(content: Text('Данные сохранены в файл')),
//                         );
//                       }).catchError((error) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(content: Text('Ошибка при сохранении данных: $error')),
//                         );
//                       });
//                     } else {
//                       // Разрешение не получено
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text('Не удалось получить разрешение на запись во внешнее хранилище.')),
//                       );
//                     }
//                   },
//                   child: Text('Сохранить данные'),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


// import 'dart:ui';

// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';

// class NotificationPage extends StatelessWidget {
//   const NotificationPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final message = ModalRoute.of(context)!.settings.arguments as RemoteMessage;

//     return Scaffold(
//       appBar: AppBar(title: Text("Notification")),
//       body: Column(
//         children: [
//           Text(message.notification!.title.toString()),
//           Text(message.notification!.body.toString()),
//           Text(message.data.toString()),
//         ],
//       ),
//     );
//   }
// }
