import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessagingService {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  static Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission();
    await _firebaseMessaging.subscribeToTopic('allUsers');
  }
}
