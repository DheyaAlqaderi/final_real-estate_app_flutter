import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:smart_real_estate/core/constant/app_constants.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../client/chat/domain/repository/notification.dart';

class NotificationWsRepository {

  static Future<void> init() async {
    final service = FlutterBackgroundService();

    await service.configure(
        iosConfiguration: IosConfiguration(
          onBackground: onIosBackground,
          onForeground: onStart,
          autoStart: true
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
        service.setAsForegroundService().ignore();
      });
      service.on('setAsBackground').listen((event) {
        service.setAsBackgroundService().ignore();
      });
    }

    service.on('stopService').listen((event) {
      service.stopSelf();
    });


    getMessage();
  }

  static void getMessage(){

    WebSocketChannel channel = IOWebSocketChannel.connect(
        '${AppConstants.baseUrl4}/ws/notifications/',
        headers: {
          'Authorization': "token 0a53a95704d2b4e2bf439563e02bd290c0fa0eb4" ?? "",
        });

    // Define the JSON body
    // final Map<String, dynamic> body = {
    //   "command": "string",
    //   "page_number": 0,
    // };
    //
    // // Send the JSON body once the connection is open
    // channel.sink.add(jsonEncode(body));

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
