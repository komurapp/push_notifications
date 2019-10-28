import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Push Notifications',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings android =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const IOSInitializationSettings ios = IOSInitializationSettings();
    const InitializationSettings initSettings =
        InitializationSettings(android, ios);

    flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: onSelectNotification);
  }

  Future<dynamic> onSelectNotification(String payload) async {
    showDialog<dynamic>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Title inside dialog'),
        content: Text('$payload'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const int delay = 3;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Local Notification'),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () => showNotification(delay),
          child: const Text('Show notification after $delay seconds'),
        ),
      ),
    );
  }

  Future<dynamic> showNotification(int delay) async {
    final int id = Random.secure().nextInt(100);
    final AndroidNotificationDetails android = AndroidNotificationDetails(
      'Channel Id',
      'Channel Name',
      'Channel Description',
      importance: Importance.Max,
      priority: Priority.High,
    );
    final IOSNotificationDetails ios = IOSNotificationDetails();
    final NotificationDetails platform = NotificationDetails(android, ios);

    await Future<dynamic>.delayed(Duration(seconds: delay));
    await flutterLocalNotificationsPlugin.show(
      id,
      'Title',
      'Body of notification with id: $id',
      platform,
      payload: '$id',
    );
  }
}
