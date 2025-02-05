import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thecook/screens/bottom_navigator_bar/my_recipe_page/controller/my_recipe_controller.dart';

class MyRecipePage extends StatefulWidget {
  const MyRecipePage({super.key});

  @override
  State<MyRecipePage> createState() => _MyRecipePageState();
}

class _MyRecipePageState extends State<MyRecipePage> {
  List<MyRecipeController> recipes = [];

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  Future<void> _loadRecipes() async {
    final loadedRecipes = await MyRecipeController.getAllMyRecipes();
    setState(() {
      recipes = loadedRecipes;
    });
  }

  Future<void> _deleteRecipe(String recipeId) async {
    try {
      await FirebaseFirestore.instance
          .collection('recipes')
          .doc(recipeId)
          .delete();
      setState(() {
        recipes.removeWhere((recipe) => recipe.recipeId == recipeId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Receta eliminada correctamente')),
      );
    } catch (e) {
      print('Error al eliminar receta: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar receta')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: recipes.isEmpty
            ? const Center(child: Text('No hay recetas aún'))
            : ListView.builder(
                itemCount: recipes.length,
                itemBuilder: (context, index) {
                  final recipe = recipes[index];
                  String formattedDate = 'Desconocida';

                  if (recipe.createdAt != null) {
                    try {
                      DateTime date = (recipe.createdAt as Timestamp).toDate();
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InteractiveViewer(
                            panEnabled: true,
                            boundaryMargin: const EdgeInsets.all(20),
                            minScale: 0.5,
                            maxScale: 3.0,
                            child: CachedNetworkImage(
                              imageUrl: recipe.imageUrl,
                              width: 100,
                              height: 90,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Center(
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
                                Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: Text(
                                          recipe.recipeName,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Montserrat',
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        _deleteRecipe(recipe.recipeId);
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  recipe.recipeDescription,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Montserrat',
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  "Fecha: $formattedDate",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Montserrat',
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
