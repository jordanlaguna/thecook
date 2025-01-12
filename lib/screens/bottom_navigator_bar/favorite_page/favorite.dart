import 'package:flutter/material.dart';

class FavoritePage extends StatelessWidget {
  static var currentState;

  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
      ),
      body: const Center(
        child: Text('Página de Favoritos'),
      ),
    );
  }
}
