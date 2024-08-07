
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessagingRepository {
  static final  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  static Future<String?> init() async{
   await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true
    );
    final token = await _firebaseMessaging.getToken();
    print(token);
    return token;
  }

  static Future<String?> getToken() async {
    return await _firebaseMessaging.getToken();
  }
}
