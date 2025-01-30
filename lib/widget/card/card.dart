import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thecook/model/recipes_list.dart';
import 'package:thecook/widget/modal_recipes/modal.dart';
import 'package:intl/intl.dart';

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
  Future<void> _updateFavorite(bool isFavorite) async {
    try {
      await FirebaseFirestore.instance
          .collection('recipes')
          .doc(widget.recipe.recipeId)
          .update({'isFavorite': isFavorite});
    } catch (e) {
      print("Error al actualizar favorito: $e");
    }
  }

  Future<void> _updateLike(bool liked) async {
    try {
      await FirebaseFirestore.instance
          .collection('recipes')
          .doc(widget.recipe.recipeId)
          .update({'liked': liked});
    } catch (e) {
      print("Error al actualizar like: $e");
    }
  }

  void _showFullImage() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.black54,
        child: Stack(
          alignment: Alignment.center,
          children: [
            InteractiveViewer(
              panEnabled: true,
              boundaryMargin: const EdgeInsets.all(20),
              minScale: 0.5,
              maxScale: 3.0,
              child: CachedNetworkImage(
                imageUrl: widget.recipe.imageUrl,
                fit: BoxFit.contain,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Center(
                    child: Icon(Icons.broken_image,
                        size: 150, color: Colors.grey)),
              ),
            ),
            Positioned(
              top: 20,
              right: 20,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
                Expanded(
                  child: Text(
                    widget.recipe.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: Icon(
                        widget.recipe.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color:
                            widget.recipe.isFavorite ? Colors.red : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          widget.recipe.isFavorite = !widget.recipe.isFavorite;
                        });
                        _updateFavorite(widget.recipe.isFavorite);
                      },
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: Icon(
                        widget.recipe.liked
                            ? Icons.thumb_up
                            : Icons.thumb_up_alt_outlined,
                        color: widget.recipe.liked ? Colors.blue : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          widget.recipe.liked = !widget.recipe.liked;
                        });
                        _updateLike(widget.recipe.liked);
                      },
                    ),
                  ],
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Por: ${widget.recipe.author}",
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _showFullImage,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: widget.recipe.imageUrl,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Center(
                      child: Icon(Icons.broken_image,
                          size: 150, color: Colors.grey)),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Fecha: ${widget.recipe.date != null ? DateFormat("yyyy-MM-dd").format(widget.recipe.date!.toDate()) : 'Desconocida'}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
            ),
            const SizedBox(height: 8),
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
