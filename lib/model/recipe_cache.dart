import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RecipeCache {
  static Future<Map<String, List<String>>> fetchRecipeDetails(
      String recipeId) async {
    final prefs = await SharedPreferences.getInstance();
    String? cachedData = prefs.getString('recipe_$recipeId');

    // Si está en caché, la retornamos
    if (cachedData != null) {
      print('📲 Cargando detalles de la receta desde caché...');
      Map<String, dynamic> decodedData = jsonDecode(cachedData);
      return {
        'ingredientes': List<String>.from(decodedData['ingredientes'] ?? []),
        'souce': List<String>.from(decodedData['souce'] ?? []),
      };
    }

    // Si no está en caché, la obtenemos de Firestore
    try {
      print("Buscando receta con UID: $recipeId en Firestore...");
      final doc = await FirebaseFirestore.instance
          .collection('recipes')
          .doc(recipeId)
          .get();

      if (doc.exists) {
        final data = doc.data();
        if (data != null) {
          List<String> ingredients =
              List<String>.from(data['ingredientes'] ?? []);
          List<String> souce = List<String>.from(data['souce'] ?? []);

          // Guardamos en caché para futuras consultas
          await prefs.setString(
              'recipe_$recipeId',
              jsonEncode({
                'ingredientes': ingredients,
                'souce': souce,
              }));

          return {'ingredientes': ingredients, 'souce': souce};
        }
      }
    } catch (e) {
      print('Error al cargar detalles de la receta: $e');
    }

    return {'ingredientes': [], 'souce': []};
  }
}
