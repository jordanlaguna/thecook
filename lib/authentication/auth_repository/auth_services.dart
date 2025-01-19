// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Verificar si el usuario ya inició sesión
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

      // Iniciar sesión con Firebase
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

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
