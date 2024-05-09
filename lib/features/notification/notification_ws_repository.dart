import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../client/chat/domain/repository/notification.dart';

class NotificationWsRepository {

  static Future<void> init() async {
    final service = FlutterBackgroundService();

    await service.configure(
        iosConfiguration: IosConfiguration(
          autoStart: true,
          onBackground: onIosBackground,
          onForeground: onStart,
        ),
        androidConfiguration: AndroidConfiguration(
            onStart: onStart,
            isForegroundMode: true,
            autoStart: true
        )
    );
  }

  @pragma('vm:entry-point')
  static Future<bool> onIosBackground(ServiceInstance service) async{
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();
    return true;
  }

  @pragma('vm:entry-point')
  static void onStart(
      ServiceInstance service) async{
    DartPluginRegistrant.ensureInitialized();
    if(service is AndroidServiceInstance){
      service.on('setAsForeground').listen((event) {
        service.setAsForegroundService();
      });
      service.on('setAsBackground').listen((event) {
        service.setAsBackgroundService();
      });
    }

    service.on('stopService').listen((event) {
      service.stopSelf();
    });



    getMessage();

    Timer.periodic(const Duration(seconds: 1), (timer) async{
      if(service is AndroidServiceInstance){
        if(await service.isForegroundService()){
          service.setForegroundNotificationInfo(title: "SCRIPT ACADEMY", content: "sub my channel");
        }
      }

      print("Background Service running");
      service.invoke('update');

    });
  }

  static void getMessage(){

    WebSocketChannel channel = IOWebSocketChannel.connect(
        'ws://192.168.0.117:8000/ws/notifications/',
        headers: {
          'Authorization': "cd1078633312c7a901f81ba427bf641b8f5113f2" ?? "",
        });
    channel.stream.listen((event) async {
      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

      // Initialize notifications if not already initialized
      NotificationInitialize.initializeNotifications(flutterLocalNotificationsPlugin);

      // Parse the JSON string into a Map
      Map<String, dynamic> data = jsonDecode(event);

      // Access the properties
      String title1 = data['notifications']['notifications']['verb'];
      String body = data['notifications']['notifications']['verb'];

      // Initialize FlutterLocalNotificationsPlugin and show notification
      await NotificationInitialize.showNotification(
        title: title1 == "Your alarm matched a new property!"? 'Alarm': 'Notification',
        body: body,
        flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin,
      );

      print(event);
    });
  }

}
