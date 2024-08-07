import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_pushtest/message.dart';
import 'package:flutter_pushtest/push_notification.dart';
import 'firebase_options.dart';
import 'home.dart';

final navigatorKey = GlobalKey<NavigatorState>();

// Function to handle background messages
Future _firebaseBackgroundMessage(RemoteMessage message) async {
  if (message.notification != null) {
    print("Notification received in the back");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase and handle potential errors
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("Firebase initialized successfully");
  } catch (e) {
    print("Error initializing Firebase: $e");
  }

  // Handle notification taps when the app is in the background
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    if (message.notification != null) {
      print("Notification tapped in the back");
      navigatorKey.currentState!.pushNamed("/message", arguments: message);
    }
  });

  // Initialize push notifications and handle errors
  try {
    await PushNotifications.init();
    await PushNotifications.localNotiInit();
    print("Push notifications initialized successfully");
  } catch (e) {
    print("Error initializing push notifications: $e");
  }

  // Listen for background notifications
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessage);

  // Handle notifications when the app is in the foreground
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    String payloadData = jsonEncode(message.data);
    print("Notification received in the fore");
    if (message.notification != null) {
      PushNotifications.showSimpleNotification(
          title: message.notification!.title!,
          body: message.notification!.body!,
          payload: payloadData);
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
