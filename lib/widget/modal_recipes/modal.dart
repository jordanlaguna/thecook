import 'package:flutter/material.dart';
import 'package:thecook/model/recipe_cache.dart';
import 'package:thecook/model/recipes_list.dart';

class RecipeDetailsModal extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailsModal({required this.recipe, super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              recipe.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            FutureBuilder<Map<String, List<String>>>(
              future: RecipeCache.fetchRecipeDetails(recipe.recipeId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text('Error al cargar detalles de la receta'),
                  );
                } else if (!snapshot.hasData ||
                    (snapshot.data!['ingredientes']!.isEmpty &&
                        snapshot.data!['souce']!.isEmpty)) {
                  return const Center(
                    child: Text('No hay detalles disponibles para esta receta'),
                  );
                }

                final ingredients = snapshot.data!['ingredientes']!;
                final souce = snapshot.data!['souce']!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (ingredients.isNotEmpty) ...[
                      const Text(
                        'Ingredientes:',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat'),
                      ),
                      const SizedBox(height: 8),
                      ...ingredients.map((ingrediente) => Text('- $ingrediente',
                          style: const TextStyle(fontSize: 16))),
                      const SizedBox(height: 16),
                    ],
                    if (souce.isNotEmpty) ...[
                      const Text(
                        'Salsas:',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat'),
                      ),
                      const SizedBox(height: 8),
                      ...souce.map((s) =>
                          Text('- $s', style: const TextStyle(fontSize: 16))),
                    ],
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cerrar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
