// ignore_for_file: avoid_print

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ImageService {
  static final FirebaseStorage _storage = FirebaseStorage.instance;
  static final FirebaseFirestore _firebaseFirestore =
      FirebaseFirestore.instance;

  static Future<String?> uploadImage(File image) async {
    final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    try {
      final String fileName = image.path.split('/').last;

      Reference ref = _storage.ref().child("pictures").child(fileName);
      final UploadTask uploadTask = ref.putFile(image);
      final TaskSnapshot snapshot = await uploadTask.whenComplete(() => true);

      // Obtenemos la URL de descarga
      final String url = await snapshot.ref.getDownloadURL();

      // Guarda la URL en Firestore
      await _firebaseFirestore.collection("user").doc(currentUserId).update({
        "photoURL": url,
      });

      return url; // Devuelve la URL de la imagen
    } catch (e) {
      print("Error al subir imagen: $e");
      return null;
    }
  }
}
