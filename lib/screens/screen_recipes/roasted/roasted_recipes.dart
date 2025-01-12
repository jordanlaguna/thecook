import 'package:flutter/material.dart';
import 'package:thecook/model/recipes_list.dart';
import 'package:thecook/widget/card/card.dart';

class RoastedPage extends StatelessWidget {
  const RoastedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Recipe> recipes = [
      Recipe(
        name: 'Pollo en salsa blanca',
        calificacion: 4.5,
        imageUrl: 'assets/chickenRep/Pollo-en-Salsa-Blanca.jpg',
        ingredientes: [
          'Para el pollo:',
          '2 pechugas de pollo',
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
        name: 'Pollo frito en salsa roja',
        calificacion: 4.9,
        imageUrl: 'assets/chickenRep/pollo-frito-con-tomate.jpg',
        ingredientes: [
          'Para el pollo frito:',
          '2 muslos de pollo',
          '1 taza de harina de trigo',
          'Sal y pimienta al gusto',
          'Para la salsa roja:',
          '1 taza de salsa de tomate',
          '1/2 cebolla picada',
          '2 dientes de ajo',
          '1/4 taza de pimiento picado',
          '1/4 taza de zanahoria picada',
          '1/4 taza de chile dulce picado',
          'Sal y pimienta al gusto',
        ],
        isFavorite: false,
      ),
      Recipe(
        name: 'Alitas fritas en salsa buffalo',
        calificacion: 4.8,
        imageUrl: 'assets/chickenRep/alitas.jpg',
        ingredientes: [
          'Para las alitas:',
          '10 alitas de pollo',
          '1 taza de harina de trigo',
          'Sal y pimienta al gusto',
          'Para la salsa buffalo:',
          '1/2 taza de salsa buffalo',
          '2 cucharadas de mantequilla',
          'Sal al gusto',
        ],
        isFavorite: false,
      ),
      Recipe(
        name: 'Cordon bleu',
        calificacion: 4.7,
        imageUrl: 'assets/chickenRep/Cordon-Bleu.jpg',
        ingredientes: [
          'Para el cordon bleu:',
          '2 pechugas de pollo',
          '2 rebanadas de jamón',
          '2 rebanadas de queso suizo',
          '1 taza de pan rallado',
          '1 huevo',
          'Sal y pimienta al gusto',
          'Para la salsa de queso:',
          '1 taza de queso cheddar',
          '1/2 taza de crema de leche',
          '1/4 taza de mantequilla',
          'Sal y pimienta al gusto',
        ],
        isFavorite: false,
      ),
      Recipe(
        name: 'Pechuga en salsa cremosa',
        calificacion: 4.6,
        imageUrl: 'assets/chickenRep/pechuga.jpg',
        ingredientes: [
          'Para la pechuga:',
          '2 pechugas de pollo',
          'Sal y pimienta al gusto',
          'Para la salsa cremosa:',
          '1 taza de crema de leche',
          '1/2 taza de espinacas',
          '1/4 taza de queso parmesano',
          '2 dientes de ajo',
          'Sal y pimienta al gusto'
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
              children: recipe.ingredientes
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
