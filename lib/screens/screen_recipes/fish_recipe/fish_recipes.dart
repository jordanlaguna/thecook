import 'package:flutter/material.dart';
import 'package:thecook/model/recipes_list.dart';
import 'package:thecook/widget/card/card.dart';

class FishPage extends StatelessWidget {
  const FishPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Recipe> recipes = [
      Recipe(
        author: 'Chef Juan',
        name: 'Filete de pescado',
        imageUrl: 'assets/fishRec/filet.jpg',
        ingredients: [
          'Para el Filet:',
          '1 filete de pescado',
          'Sal y pimienta al gusto',
          'Para la salsa blanca:',
          '1 taza de crema de leche',
          '1/2 taza de champiñones',
          '1/4 taza de queso parmesano',
          'Sal y pimienta al gusto'
        ],
        isFavorite: false,
      ),
      Recipe(
        author: 'Jordan Laguna',
        name: 'Camarones salsa de coco',
        imageUrl: 'assets/fishRec/camaron.jpg',
        ingredients: [
          'Para los camarones:',
          '10 camarones',
          '1 taza de harina de trigo',
          'Sal y pimienta al gusto',
          'Para la salsa de coco:',
          '1 taza de leche de coco',
          '1/2 cebolla picada',
          '2 dientes de ajo',
          '1 taza de tocino picado y frito',
          '1/4 taza de cilantro picado',
          'Sal y pimienta al gusto',
        ],
        isFavorite: false,
      ),
      Recipe(
        author: 'Jordan Laguna',
        name: 'Mariscada con pasta',
        imageUrl: 'assets/fishRec/mariscada.jpg',
        ingredients: [
          'Para la mariscada:',
          '1 bolsa de mariscos',
          '1 taza de vino blanco',
          'Sal y pimienta al gusto',
          'Para la pasta:',
          '1 taza de pasta',
          '1/2 taza de crema de leche',
          '1/4 taza de queso parmesano',
          'Sal y pimienta al gusto',
        ],
        isFavorite: false,
      ),
      Recipe(
        author: 'Jordan Laguna',
        name: 'Pasta con camarones',
        imageUrl: 'assets/fishRec/pasta_con_camarones.jpg',
        ingredients: [
          'Para los camarones:',
          '10 camarones',
          '1 mantequilla',
          'Sal y pimienta al gusto',
          'Para la pasta:',
          '1 taza de pasta',
          '1/2 taza de crema de leche',
          '1/4 taza de queso mozzarella',
          'Sal y pimienta al gusto',
        ],
        isFavorite: false,
      ),
      Recipe(
        author: 'Jordan Laguna',
        name: 'Pulpo con plumas',
        imageUrl: 'assets/fishRec/pulpo.jpg',
        ingredients: [
          'Para el pulpo:',
          '1 pulpo',
          'Asustar con agua hirviendo el pulpo 3 veces',
          'Hervirlo con sal y pimienta por 30 minutos',
          'Para la salsa de plumas:',
          '1 taza de salsa de tomate',
          '1/2 taza de cebolla picada',
          '1/2 taza de ajo picado',
          '1/2 taza de perejil picado',
          '1/2 taza de crema de leche',
          '1/2 taza de mantequilla',
          'Sal y pimienta al gusto',
        ],
        isFavorite: false,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CookRecep',
          style: TextStyle(
            fontSize: 24,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              colors: [
                Colors.orange[900]!,
                Colors.orange[800]!,
                Colors.orange[400]!,
              ],
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white, size: 35),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange[50]!, Colors.orange[100]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: recipes.length,
          itemBuilder: (context, index) {
            return RecipeCard(
              recipe: recipes[index],
            );
          },
        ),
      ),
    );
  }
}

// Widget que muestra los detalles de la receta
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
            Text(
              'Ingredientes:',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: recipe.ingredients
                  .map((ingrediente) => Text(
                        '- $ingrediente',
                        style: const TextStyle(fontSize: 16),
                      ))
                  .toList(),
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
