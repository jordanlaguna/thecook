import 'package:flutter/material.dart';
import 'package:thecook/widget/form_recipes/recipe_form.dart';

class AddRecipePage extends StatelessWidget {
  const AddRecipePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Agregar Receta',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w400,
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
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: RecipeForm(),
        ),
      ),
    );
  }
}
