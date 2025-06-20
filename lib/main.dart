import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:smart_guardian_final/models/log.dart';
import 'firebase_options.dart';

import 'package:smart_guardian_final/helpers/shared_preferences_helper.dart';

// Import Pages
import 'package:smart_guardian_final/pages/login.dart';
import 'package:smart_guardian_final/tab/tab_view.dart';

// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async 
// {
//   final Map<String, dynamic> data = message.data;
//   print('Handling a background message ${data}');
// }

void main() async 
{
    try 
    {
        WidgetsFlutterBinding.ensureInitialized();
        
        await SharedPreferencesHelper().init();
        await Firebase.initializeApp();
        // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
        await _initializeMessaging();

        print('Firebase initialized');
    } 
    catch(e) 
    {
        print('Firebase init error: $e');
    }
    runApp(const MyApp());
}

Future<void> _initializeMessaging() async
{
    final FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging.requestPermission();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('📢 Notifikasi diterima: ${message.notification?.title}');
    });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: (SharedPreferencesHelper().getDeviceID() == null) ? LoginPage() : TabView(),
    );
  }
}