


import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationInitialize{
  static Future<void> initializeNotifications(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var initializationSettingsAndroid = const AndroidInitializationSettings('@drawable/ic_launcher');
    // var initializationSettingsIOS = IOSInitializationSettings();


    final InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid, iOS: null, macOS: null);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }


  static Future<void> showNotification(
      {var id = 0,
      required String title,
      required String body,
      var payload,
      required FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      }) async {


    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'you_can_name_it_whatever',
      'flutterfcm',
      // 'your_channel_description', // description
      playSound: true,
      sound: RawResourceAndroidNotificationSound('notification'),
      importance: Importance.max,
      priority: Priority.high,

    );

    var not = const NotificationDetails(android: androidPlatformChannelSpecifics);

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0, // notification id
      title, // title
      body, // body
      not
    );
  }
}