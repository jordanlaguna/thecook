// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileController {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> getUserPhotoURL(String uid) async {
    DocumentSnapshot userDoc =
        await _firebaseFirestore.collection('user').doc(uid).get();
    try {
      // validamos que el documento exista y que tenga datos
      if (userDoc.exists && userDoc.data() != null) {
        Map<String, dynamic> userData = userDoc.data()! as Map<String, dynamic>;
        if (userData['photoURL'] != null) {
          return userData['photoURL'];
        }
      }

      // revisamos si el usuario tiene una foto de perfil en google auth
      User? user = _auth.currentUser;
      if (user != null && user.photoURL != null) {
        return user.photoURL;
      }
    } catch (e) {
      print('Error obteniendo datos del usuario: $e');
    }
    return null;
  }

  // extraemos el nombre del usuario de la base de datos
  Future<Map<String, dynamic>?> getUserData(String? uid) async {
    if (uid == null) return null;
    try {
      DocumentSnapshot<Map<String, dynamic>> userData =
          await _firebaseFirestore.collection('user').doc(uid).get();
      return userData.data();
    } catch (e) {
      print('Error obteniendo datos del usuario: $e');
      return null;
    }
  }
}
