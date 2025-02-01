import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DetailsModal extends StatelessWidget {
  final String recipeId;

  const DetailsModal({required this.recipeId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future:
          FirebaseFirestore.instance.collection('recipes').doc(recipeId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Error al cargar la receta'));
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Center(child: Text('Receta no encontrada'));
        }

        var recipe = snapshot.data!.data() as Map<String, dynamic>;

        final ingredients = List<String>.from(recipe['ingredientes'] ?? []);
        final souce = List<String>.from(recipe['souce'] ?? []);

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipe['name'],
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
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
      },
    );
  }
}
