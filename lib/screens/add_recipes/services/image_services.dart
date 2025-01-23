// ignore_for_file: avoid_print

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ImageService {
  static final FirebaseStorage _storage = FirebaseStorage.instance;
  static final FirebaseFirestore _firebaseFirestore =
      FirebaseFirestore.instance;

  static Future<String?> uploadImage(File image, String recipeId) async {
    try {
      final String fileName = image.path.split('/').last;

      // save the image in Firebase Storage
      Reference ref = _storage.ref().child("recipe").child(fileName);
      final UploadTask uploadTask = ref.putFile(image);
      final TaskSnapshot snapshot = await uploadTask.whenComplete(() => true);

      // get url from the image
      final String url = await snapshot.ref.getDownloadURL();

      // save the url in Firestore in the recipe document
      await _firebaseFirestore.collection("recipes").doc(recipeId).update({
        "imageURL": url,
      });

      return url;
    } catch (e) {
      print("Error al subir imagen: $e");
      return null;
    }
  }
}
