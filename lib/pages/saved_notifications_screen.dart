import 'package:flutter/material.dart';
import 'notification_storage.dart';

class SavedNotificationsScreen extends StatefulWidget {
  const SavedNotificationsScreen({Key? key}) : super(key: key);

  @override
  _SavedNotificationsScreenState createState() => _SavedNotificationsScreenState();
}

class _SavedNotificationsScreenState extends State<SavedNotificationsScreen> {
  final NotificationStorage _notificationStorage = NotificationStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Сохраненные уведомления',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xff025097),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _deleteAllNotifications(context);
            },
          ),
        ],
      ),
      body: FutureBuilder<List<String>>(
        future: _notificationStorage.getNotifications(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          }

          List<String> notifications = snapshot.data ?? [];

          if (notifications.isEmpty) {
            return Center(child: Text('Нет сохраненных уведомлений'));
          }

          // Удаление дубликатов уведомлений
          Set<String> uniqueNotifications = {};
          List<String> uniqueNotificationsList = [];

          for (String notification in notifications) {
            List<String> notificationData = notification.split('|');
            String title = notificationData[0];
            String body = notificationData[1];
            String dateTime = notificationData[2];
            String notificationKey = '$title|$body|$dateTime';

            // Проверяем наличие уникального ключа в множестве
            if (!uniqueNotifications.contains(notificationKey)) {
              uniqueNotifications.add(notificationKey);
              uniqueNotificationsList.add(notification);
            }
          }

          return ListView.builder(
            itemCount: uniqueNotificationsList.length,
            itemBuilder: (context, index) {
              List<String> notificationData = uniqueNotificationsList[index].split('|');
              String title = notificationData[0];
              String body = notificationData[1];
              String dateTime = notificationData[2];

              return ListTile(
                title: Text(title),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(body),
                    SizedBox(height: 4),
                    Text(dateTime, style: TextStyle(color: Colors.grey)),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _deleteAllNotifications(BuildContext context) async {
    try {
      await _notificationStorage.deleteAllNotifications();
      setState(() {}); 
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Все уведомления удалены")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Ошибка при удалении уведомлений: $e")),
      );
    }
  }
}
