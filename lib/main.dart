import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:thecook/authentication/screen/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());

  final String filePath = 'assets/services_account_file.json';

  try {
    final String jsonString = File(filePath).readAsStringSync();
    final Map<String, dynamic> jsonData = jsonDecode(jsonString);
    print('Archivo JSON cargado con éxito: $jsonData');
  } catch (e) {
    print('Error al leer el archivo: $e');
  }

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission();

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print("Permiso de notificación autorizado");
  } else {
    print("Permiso de notificación no autorizado");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Este widget es la raíz de tu aplicación.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Recetas de Cocina',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const LoginScreen());
  }
}

Future<void> updateFCMToken() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken != null) {
      await FirebaseFirestore.instance.collection('user').doc(user.uid).update({
        'fcmToken': fcmToken,
      });
      print('FCM Token actualizado con éxito');
    }
  }
}
