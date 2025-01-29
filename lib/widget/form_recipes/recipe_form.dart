import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:thecook/model/recipes_list.dart';
import 'package:thecook/screens/add_recipes/controller/recipes_add.dart';
import 'package:thecook/screens/add_recipes/services/image_services.dart';

class RecipeForm extends StatefulWidget {
  const RecipeForm({super.key});

  @override
  State<RecipeForm> createState() => _RecipeFormState();
}

class _RecipeFormState extends State<RecipeForm> {
  final TextEditingController _recipeNameController = TextEditingController();
  final TextEditingController _recipeIngredientsController =
      TextEditingController();
  final TextEditingController _recipeSouceController = TextEditingController();
  File? _imageFile;
  String? imageUrl;
  String? _selectedCategory;

  final List<String> _categories = [
    'Carne blanca',
    'Carne roja',
    'Mariscos',
    'Asados',
    'Pastas',
  ];

  late RecipesAdd _recipesAdd;

  @override
  void initState() {
    super.initState();

    _recipesAdd = RecipesAdd(
      recipe: Recipe(
        name: '',
        author: '',
        imageUrl: '',
        ingredients: [],
        recipeId: '',
      ),
    );
  }

  // method to pick an image from the gallery
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    } else {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.info,
        text: 'No seleccionaste ninguna imagen.',
        autoCloseDuration: const Duration(seconds: 3),
        showConfirmBtn: false,
      );
    }
  }

  // Method to save the recipe
  void _saveRecipe() async {
    final String recipeName = _recipeNameController.text.trim();
    final String ingredientsText = _recipeIngredientsController.text.trim();
    final String souceText = _recipeSouceController.text.trim();

    if (recipeName.isEmpty ||
        ingredientsText.isEmpty ||
        souceText.isEmpty ||
        _selectedCategory == null ||
        _imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Todos los campos son obligatorios.')),
      );
      return;
    }

    final List<String> ingredients = ingredientsText.split(',');
    final List<String> souce = souceText.split(',');

    try {
      // call the addRecipe method from RecipesAdd
      String? recipeId = await _recipesAdd.addRecipe(
        context,
        recipeName,
        ingredients,
        souce,
        category: _selectedCategory!,
      );

      if (recipeId != null && _imageFile != null) {
        // upload the image to Firebase Storage
        String? imageUrl =
            await ImageService.uploadImage(_imageFile!, recipeId);
        if (imageUrl != null) {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            text: 'Receta guardada con éxito!',
            autoCloseDuration: const Duration(seconds: 3),
            showConfirmBtn: false,
          );
        }
      }

      // clean the text fields
      _recipeNameController.clear();
      _recipeIngredientsController.clear();
      _recipeSouceController.clear();
      setState(() {
        _imageFile = null;
      });
    } catch (e) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: 'No se pudo guardar la receta.',
        autoCloseDuration: const Duration(seconds: 3),
        showConfirmBtn: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nombre de la receta',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontFamily: 'Montserrat',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _recipeNameController,
              decoration: InputDecoration(
                hintText: 'Ej. Pasta al pesto',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Categoría de la receta',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontFamily: 'Montserrat',
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              hint: const Text('Selecciona una categoría'),
              items: _categories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCategory = newValue;
                });
              },
              validator: (value) =>
                  value == null ? 'Por favor selecciona una categoría' : null,
            ),
            const SizedBox(height: 12),
            const Text(
              'Ingredientes para la receta (separados por comas)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontFamily: 'Montserrat',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _recipeIngredientsController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Ej. 200g de pasta, 2 dientes de ajo, etc.',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Ingredientes para la salsa (separados por comas)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontFamily: 'Montserrat',
              ),
            ),
            TextField(
              controller: _recipeSouceController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Ej. una taza de tomate, 2 dientes de ajo, etc.',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Foto de la receta',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontFamily: 'Montserrat',
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Column(
                children: [
                  imageUrl != null
                      ? CircleAvatar(
                          radius: 60,
                          backgroundImage: NetworkImage(imageUrl!),
                        )
                      : _imageFile != null
                          ? CircleAvatar(
                              radius: 60,
                              backgroundImage: FileImage(_imageFile!),
                            )
                          : CircleAvatar(
                              radius: 60,
                              child: Icon(
                                Icons.image,
                                size: 50,
                                color: Colors.orange[900],
                              ),
                            ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    icon: const Icon(
                      Icons.image,
                      color: Colors.white,
                    ),
                    onPressed: _pickImage,
                    label: const Text(
                      'Seleccionar imagen',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        fontSize: 16,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                      backgroundColor: Colors.orange[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  _saveRecipe();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                  backgroundColor: Colors.orange[800],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text(
                  'Guardar Receta',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
