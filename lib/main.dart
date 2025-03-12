import 'dart:convert';
import 'package:flutter/services.dart'; // Necesario para leer archivos desde assets
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:thecook/authentication/screen/login_screen.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Mensaje en segundo plano: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  try {
    final String jsonString =
        await rootBundle.loadString('assets/services_account_file.json');
    final Map<String, dynamic> jsonData = jsonDecode(jsonString);
    print(jsonData);
  } catch (e) {
    print('Error al leer el archivo JSON: $e');
  }

  // Configurar Firebase Messaging
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission();

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print("Permiso de notificación autorizado");
  } else {
    print("Permiso de notificación no autorizado");
  }

  // Manejo de mensajes en segundo plano
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await updateFCMToken();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recetas de Cocina',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}

Future<void> updateFCMToken() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken != null) {
      await FirebaseFirestore.instance.collection('user').doc(user.uid).set(
        {'fcmToken': fcmToken},
        SetOptions(merge: true),
      );
      print('FCM Token actualizado con éxito');
    }
  }
}
