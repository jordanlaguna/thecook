// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:thecook/main.dart';
import 'package:thecook/model/user.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredential?> signInWithGoogle() async {
    try {
      // verify if the user is already signed in
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        print("El usuario canceló el inicio de sesión.");
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // signIn with credential
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      UserModel user = UserModel(
        uid: userCredential.user?.uid ?? '',
        name: googleUser.displayName ?? 'Nombre no disponible',
        email: googleUser.email,
      );

      // verify if the user exists in Firestore
      final userDoc = _firestore.collection('user').doc(user.uid);
      final docSnapshot = await userDoc.get();
      await updateFCMToken();
      if (!docSnapshot.exists) {
        await userDoc.set(user.toMap());
        print("Usuario guardado en Firestore.");
      } else {
        print("El usuario ya existe en Firestore.");
      }

      print("Inicio de sesión exitoso: ${userCredential.user?.displayName}");
      return userCredential;
    } catch (e) {
      print("Error en Google Sign-In: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    await googleSignIn.signOut();
    await _auth.signOut();
    print("Sesión cerrada");
  }
}
