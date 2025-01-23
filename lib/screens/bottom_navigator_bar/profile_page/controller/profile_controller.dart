import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileController {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> getUserPhotoURL(String uid) async {
    try {
      // extraction of the user's photo
      DocumentSnapshot userDoc =
          await _firebaseFirestore.collection('user').doc(uid).get();
      if (userDoc.exists && userDoc.data() != null) {
        Map<String, dynamic> userData = userDoc.data()! as Map<String, dynamic>;
        if (userData['photoURL'] != null) {
          return userData['photoURL'];
        }
      }

      // the user's photo is not in Firestore, so we get it from Firebase Authentication
      User? user = _auth.currentUser;
      if (user != null && user.photoURL != null) {
        return user.photoURL;
      }
    } catch (e) {
      print('Error obteniendo la foto de perfil: $e');
    }
    return null;
  }

  Future<Map<String, dynamic>> getUserData(String uid) async {
    try {
      // extraction of the user's data from Firebase Authentication
      User? user = _auth.currentUser;
      Map<String, dynamic> authData = {
        'name': user?.displayName ?? 'Nombre no disponible',
        'email': user?.email ?? 'Correo no disponible',
      };

      // Obtener datos adicionales de Firestore
      DocumentSnapshot<Map<String, dynamic>> userData =
          await _firebaseFirestore.collection('user').doc(uid).get();
      if (userData.exists && userData.data() != null) {
        return {
          ...authData,
          ...userData.data()!,
        };
      }

      return authData;
    } catch (e) {
      print('Error obteniendo los datos del usuario: $e');
      return {
        'name': 'Nombre no disponible',
        'email': 'Correo no disponible',
      };
    }
  }
}
