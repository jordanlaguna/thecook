import 'package:cloud_firestore/cloud_firestore.dart';

class Recipe {
  final String recipeId;
  final String name;
  final String author;
  final Timestamp? date;
  final String imageUrl;
  final List<String> ingredients;
  bool isFavorite;
  bool liked;

  Recipe({
    required this.recipeId,
    required this.name,
    required this.author,
    required this.imageUrl,
    this.date,
    required this.ingredients,
    this.isFavorite = false,
    this.liked = false,
  });

  // Función para obtener todas las recetas desde Firestore
  static Future<List<Recipe>> getAllRecipes() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final QuerySnapshot<Map<String, dynamic>> snapshot =
        await firestore.collection('recipes').get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Recipe(
        recipeId: data['recipeId'] ?? '',
        name: data['name'] ?? 'Nombre desconocido',
        author: data['author'] ?? 'Autor desconocido',
        imageUrl: data['imageURL'] ?? '',
        ingredients: List<String>.from(data['ingredients'] ?? []),
        isFavorite: data['isFavorite'] ?? false,
        liked: data['liked'] ?? false,
      );
    }).toList();
  }

  // Método para convertir un documento de Firestore a un objeto Recipe
  factory Recipe.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Recipe(
      recipeId: data['recipeId'] ?? '',
      name: data['name'] ?? 'Nombre desconocido',
      author: data['author'] ?? 'Autor desconocido',
      imageUrl: data['imageURL'] ?? '',
      date: data['date'] as Timestamp?,
      ingredients: List<String>.from(data['ingredients'] ?? []),
      isFavorite: data['isFavorite'] ?? false,
      liked: data['liked'] ?? false,
    );
  }

  // Función para obtener recetas filtradas por categoría
  static Future<List<Recipe>> getRecipesByCategory(String category) async {
    print("🔍 Buscando recetas con categoría EXACTA: '$category'");

    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    QuerySnapshot snapshot = await firestore
        .collection('recipes')
        .where('category', isEqualTo: category)
        .get();

    print("📄 Documentos encontrados: ${snapshot.docs.length}");

    if (snapshot.docs.isEmpty) {
      print("No se encontraron recetas con la categoría '$category'");
    } else {
      for (var doc in snapshot.docs) {
        print("Receta encontrada: ${doc.data()}");
      }
    }

    return snapshot.docs.map((doc) => Recipe.fromFirestore(doc)).toList();
  }
}
