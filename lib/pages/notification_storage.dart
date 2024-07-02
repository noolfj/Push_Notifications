import 'package:shared_preferences/shared_preferences.dart';

class NotificationStorage {
  static const String _storageKey = 'saved_notifications';

  Future<void> saveNotification(String title, String body, String dateTime) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> notifications = prefs.getStringList(_storageKey) ?? [];
    notifications.add('$title|$body|$dateTime');
    await prefs.setStringList(_storageKey, notifications);
  }

  Future<List<String>> getNotifications() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_storageKey) ?? [];
  }

  Future<void> deleteNotification(int index) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> notifications = prefs.getStringList(_storageKey) ?? [];
    notifications.removeAt(index);
    await prefs.setStringList(_storageKey, notifications);
  }

  Future<void> deleteAllNotifications() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
  Future<bool> isNotificationSaved(String title) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> notifications = prefs.getStringList(_storageKey) ?? [];
  return notifications.any((notification) => notification.startsWith('$title|'));
}

}

