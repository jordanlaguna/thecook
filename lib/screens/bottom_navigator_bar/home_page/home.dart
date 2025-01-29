import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Importa Firebase
import 'package:thecook/screens/screen_recipes/fish_recipe/screen/fish_recipes.dart';
import 'package:thecook/screens/screen_recipes/red_steak/screen/steak_red.dart';
import 'package:thecook/screens/screen_recipes/roasted/screen/roasted_recipes.dart';
import 'package:thecook/screens/screen_recipes/pasta/screen/pastas.dart';
import 'package:thecook/screens/screen_recipes/white_steak/screen/steak_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Función para obtener el total de recetas por categoría
  Future<int> _getRecipeCount(String category) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('recipes')
        .where('category', isEqualTo: category)
        .get();
    return snapshot.size;
  }

  @override
  Widget build(BuildContext context) {
    // Lista de categorías con imágenes
    final List<Map<String, dynamic>> categories = [
      {
        'name': 'Carnes Blancas',
        'category': 'Carne blanca',
        'image': 'assets/home_page/white_steak.jpg',
        'route': SteakPage(category: 'Carne blanca'),
      },
      {
        'name': 'Carnes Rojas',
        'category': 'Carne roja',
        'image': 'assets/home_page/red_steak.jpg',
        'route': SteakRedPage(category: 'Carne roja'),
      },
      {
        'name': 'Mariscos',
        'category': 'Mariscos',
        'image': 'assets/home_page/fish.jpg',
        'route': FishPage(category: 'Mariscos'),
      },
      {
        'name': 'Asados',
        'category': 'Asados',
        'image': 'assets/home_page/roasted.jpg',
        'route': RoastedPage(category: 'Asados'),
      },
      {
        'name': 'Pastas',
        'category': 'Pastas',
        'image': 'assets/home_page/pastas.jpg',
        'route': PastasPage(category: 'Pastas'),
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Recetas de Cocina',
            style: TextStyle(
                fontSize: 24,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          String category = categories[index]['category'];

          return FutureBuilder<int>(
            future: _getRecipeCount(category),
            builder: (context, snapshot) {
              int totalRecipes = snapshot.data ?? 0;
              return RecipeCard(
                name: categories[index]['name'],
                total: totalRecipes,
                imageUrl: categories[index]['image'],
                route: categories[index]['route'],
              );
            },
          );
        },
      ),
    );
  }
}

// Widget personalizado para mostrar cada sección
class RecipeCard extends StatelessWidget {
  final String name;
  final int total;
  final String imageUrl;
  final Widget route;

  const RecipeCard({
    required this.name,
    required this.total,
    required this.imageUrl,
    required this.route,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Título de la categoría
            Text(
              name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            // Imagen de la categoría
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imageUrl,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),
            // Total de recetas
            Text(
              'Total de recetas: $total',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => route,
                    ));
              },
              child: const Text(
                'Ver recetas',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                  fontFamily: "Montserrat",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
