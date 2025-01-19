import 'package:flutter/material.dart';

class AddRecipePage extends StatelessWidget {
  const AddRecipePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Receta'),
      ),
      body: const Center(
        child: Text('Formulario para agregar una nueva receta'),
      ),
    );
  }
}
