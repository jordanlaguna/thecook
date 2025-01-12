import 'package:flutter/material.dart';
import 'package:thecook/model/recipes_list.dart';
import 'package:thecook/widget/modal_recipes/modal.dart';

class RecipeCard extends StatefulWidget {
  final Recipe recipe;

  const RecipeCard({
    required this.recipe,
    super.key,
  });

  @override
  _RecipeCardState createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.recipe.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    widget.recipe.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: widget.recipe.isFavorite ? Colors.red : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      widget.recipe.isFavorite = !widget.recipe.isFavorite;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                widget.recipe.imageUrl,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Calificación: ${widget.recipe.calificacion}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  builder: (BuildContext context) {
                    return RecipeDetailsModal(recipe: widget.recipe);
                  },
                );
              },
              child: const Text(
                'Ver receta',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                  fontFamily: "monserrat",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
