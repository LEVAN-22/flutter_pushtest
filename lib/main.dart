import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_pushtest/message.dart';
import 'package:flutter_pushtest/push_notification.dart';
import 'firebase_options.dart';
import 'home.dart';

final navigatorKey = GlobalKey<NavigatorState>();

// function to listen to back changes
Future _firebaseBackgroundMessage(RemoteMessage message) async {
  if (message.notification != null) {
    print("some notification Recevied");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // on back notifi tapped
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    if (message.notification != null) {
      print("Background Notifi Tapped!");
      navigatorKey.currentState!.pushNamed("/message", arguments: message);
    }
  });

  PushNotifications.intt();
  PushNotifications.localNotiInit();

  // listen to back notifi
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessage);

  // to handle fore notifi
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    String PayloadData = jsonEncode(message.data);
    print("got a message in fore");
    if (message.notification != null) {
      PushNotifications.showSimpleNotification(
          title: message.notification!.title!,
          body: message.notification!.body!,
          payload: PayloadData);
    }
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Push notifi',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        '/': (context) => const HomePage(),
        '/message': (context) => const Message()
      },
    );
  }
}
