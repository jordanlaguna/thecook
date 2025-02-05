import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyRecipeController {
  final String recipeName;
  final String recipeDescription;
  final Timestamp? createdAt;
  final String imageUrl;
  final String uid;
  final String recipeId;

  MyRecipeController({
    required this.recipeName,
    required this.recipeDescription,
    this.createdAt,
    required this.imageUrl,
    required this.uid,
    required this.recipeId,
  });

  // Método para obtener recetas del usuario actual
  static Future<List<MyRecipeController>> getAllMyRecipes() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final FirebaseAuth auth = FirebaseAuth.instance;

    final String? currentUserUid = auth.currentUser?.uid;
    if (currentUserUid == null) {
      return [];
    }
    final QuerySnapshot<Map<String, dynamic>> snapshot =
        await firestore.collection('recipes').get();
    return snapshot.docs
        .map((doc) {
          final data = doc.data();
          return MyRecipeController(
            recipeName: data['name'] ?? '',
            recipeDescription: data['category'] ?? 'Descripción desconocida',
            createdAt: data['date'] as Timestamp?,
            imageUrl: data['imageURL'] ?? '',
            uid: data['uid'] ?? '',
            recipeId: doc.id,
          );
        })
        .where((recipe) => recipe.uid == currentUserUid)
        .toList();
  }
}
