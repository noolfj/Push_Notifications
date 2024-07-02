import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'notification_storage.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final NotificationStorage _notificationStorage = NotificationStorage();
  bool _isLoading = true;
  RemoteMessage? _message;
  bool _notificationSaved = false;
  bool _notificationOpenedByUser = false; 

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializePage();
  }

  Future<void> _initializePage() async {
    if (_message == null) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is RemoteMessage) {
        _message = args;
      }
    }

    if (_message != null && !_notificationOpenedByUser) {
      if (await _notificationStorage.isNotificationSaved(_message!.notification!.title ?? '')) {
        setState(() {
          _isLoading = false;
          _notificationSaved = true; 
        });
      } else {
        String? title = _message!.notification?.title;
        String? body = _message!.notification?.body;
        String dateTime = DateFormat('yyyy-MM-dd – HH:mm').format(_message!.sentTime ?? DateTime.now());


        setState(() {
          _isLoading = false;
          _notificationSaved = true; 
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
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
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_message == null) {

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
          child: Text("Нет данных об уведомлении"),
        ),
      );
    }

    String? imageUrl = _message!.notification?.android?.imageUrl ?? _message!.data['image'];
    String dateTime = _message!.sentTime != null
        ? DateFormat('yyyy-MM-dd – HH:mm').format(_message!.sentTime!)
        : '';

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
            color: Colors.white,
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
                        fit: BoxFit.cover, 
                        placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
                      ),
                    ),
                  SizedBox(height: imageUrl != null ? 16 : 0),
                  Text(
                    _message!.notification!.title ?? '',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff025097),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    _message!.notification!.body ?? '',
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
    );
  }
}
