import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoriteController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<Map<String, dynamic>>> getFavoritesRecipes() async {
    List<Map<String, dynamic>> favoriteRecipes = [];

    try {
      String? userId = _auth.currentUser?.uid;
      if (userId == null) return [];

      // Obtener lista de recetas favoritas del usuario
      QuerySnapshot favoriteSnapshot = await _firestore
          .collection('favorites')
          .doc(userId)
          .collection('recipes')
          .get();

      for (var doc in favoriteSnapshot.docs) {
        String recipeId = doc.id;

        // Consultar la receta en la colección principal "recipes"
        DocumentSnapshot recipeDoc =
            await _firestore.collection('recipes').doc(recipeId).get();

        if (recipeDoc.exists) {
          Map<String, dynamic> recipeData =
              recipeDoc.data() as Map<String, dynamic>;
          favoriteRecipes.add(recipeData);
        }
      }
    } catch (e) {
      print("Error al obtener recetas favoritas: $e");
    }

    return favoriteRecipes;
  }
}
