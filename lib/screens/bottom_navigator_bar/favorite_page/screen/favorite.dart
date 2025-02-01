import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thecook/screens/bottom_navigator_bar/favorite_page/controller/favorite_controller.dart';
import 'package:thecook/widget/modal_recipes/details_modal.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    final FavoriteController favoriteController = FavoriteController();

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Favoritos')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: favoriteController.getFavoritesRecipes(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(child: Text('Error al cargar favoritos'));
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text('No tienes recetas favoritas aún'),
              );
            }
            final favoriteRecipes = snapshot.data!;
            return ListView.builder(
              itemCount: favoriteRecipes.length,
              itemBuilder: (context, index) {
                final recipe = favoriteRecipes[index];

                // Convertimos la fecha de Firestore (Timestamp) a DateTime
                String formattedDate = 'Desconocida';
                if (recipe['date'] != null) {
                  try {
                    DateTime date = (recipe['date'] as Timestamp).toDate();
                    formattedDate = DateFormat("yyyy-MM-dd").format(date);
                  } catch (e) {
                    print("Error al convertir fecha: $e");
                  }
                }

                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InteractiveViewer(
                          panEnabled: true,
                          boundaryMargin: const EdgeInsets.all(20),
                          minScale: 0.5,
                          maxScale: 3.0,
                          child: CachedNetworkImage(
                            imageUrl: recipe["imageURL"],
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) => const Center(
                              child: Icon(Icons.broken_image,
                                  size: 100, color: Colors.grey),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                recipe['name'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  fontFamily: 'Montserrat',
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "Categoría: ${recipe['category']}",
                                style: const TextStyle(
                                    fontSize: 14, fontFamily: 'Montserrat'),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "Autor: ${recipe['author']}",
                                style: const TextStyle(
                                    fontSize: 12, fontFamily: 'Montserrat'),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "Fecha: $formattedDate",
                                style: const TextStyle(
                                    fontSize: 12, fontFamily: 'Montserrat'),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 5),
                              TextButton(
                                onPressed: () {
                                  _showRecipeDetails(
                                      context, recipe['recipeId']);
                                },
                                child: const Text(
                                  'Ver receta',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                    fontFamily: 'Montserrat',
                                    fontSize: 14,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _showRecipeDetails(BuildContext context, String recipeId) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return DetailsModal(recipeId: recipeId);
      },
    );
  }
}
