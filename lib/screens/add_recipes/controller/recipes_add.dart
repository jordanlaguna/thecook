import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thecook/model/recipes_list.dart';

class RecipesAdd {
  Recipe recipe;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RecipesAdd({
    required this.recipe,
  });

  // Method to add a recipe to Firestore
  Future<String?> addRecipe(
    BuildContext context,
    String name,
    List<String> ingredientes,
    List<String> souce, {
    required String category,
  }) async {
    try {
      // get the user uid
      String uid = _auth.currentUser?.uid ?? '';
      if (uid.isEmpty) {
        _showDialog(context, 'Error', 'El usuario no está registrado.');
        return null;
      }
      DocumentSnapshot userDoc =
          await _firestore.collection('user').doc(uid).get();

      if (!userDoc.exists) {
        _showDialog(
            context, 'Error', 'No se encontró información del usuario.');
        return null;
      }
      // get the user name or set a default value

      String author = userDoc['name'] ?? 'Autor desconocido';
      // create a new recipe document
      DocumentReference docRef = await _firestore.collection('recipes').add({
        'uid': uid,
        'name': name,
        'author': author,
        'ingredientes': ingredientes,
        'souce': souce,
        'category': category,
        'date': FieldValue.serverTimestamp(),
      });
      // update the recipeId field with the document uid
      await docRef.update({
        'recipeId': docRef.id,
      });
      return docRef.id;
    } catch (e) {
      _showDialog(context, 'Error', 'Ocurrió un error: ${e.toString()}');
      return null;
    }
  }

  // Method to show a SnackBar
/*void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
*/
  // Method to show an AlertDialog
  void _showDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
