import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {
  final _finalbaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    // request permission form user
    await _finalbaseMessaging.requestPermission();

    //fetch the FCM Token for this device
    final fCMToken = await _finalbaseMessaging.getToken();
    print('Token: $fCMToken');
  }
}
