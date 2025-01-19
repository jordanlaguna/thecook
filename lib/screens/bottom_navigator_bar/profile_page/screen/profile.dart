import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thecook/screens/bottom_navigator_bar/profile_page/controller/profile_controller.dart';
import 'package:thecook/widget/add_recipes/add_recipes.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Perfil'),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 40.0, left: 16.0, right: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Foto de perfil
              CircleAvatar(
                radius: 80,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  child: ClipOval(
                    child: FutureBuilder<String?>(
                      future: ProfileController().getUserPhotoURL(
                        FirebaseAuth.instance.currentUser!.uid,
                      ),
                      builder: (context, snapShot) {
                        if (snapShot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }
                        if (snapShot.hasError) {
                          return const Icon(Icons.error);
                        } else {
                          if (snapShot.hasData && snapShot.data!.isNotEmpty) {
                            return Image.network(
                              snapShot.data!,
                              fit: BoxFit.cover,
                              width: 100,
                              height: 100,
                            );
                          } else {
                            return const Icon(Icons.account_circle, size: 50);
                          }
                        }
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Nombre del usuario
              FutureBuilder<DocumentSnapshot>(
                future: _firebaseFirestore
                    .collection('user')
                    .doc(_auth.currentUser!.uid)
                    .get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapShot) {
                  if (snapShot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapShot.hasError) {
                    return const Text("Error al cargar los datos");
                  }
                  if (snapShot.hasData && snapShot.data!.exists) {
                    Map<String, dynamic> userData =
                        snapShot.data!.data() as Map<String, dynamic>;
                    return Text(
                      userData['name'] ?? 'Nombre no disponible',
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  } else {
                    return const Text("Usuario no encontrado");
                  }
                },
              ),
              const SizedBox(height: 40),
              // Botón para agregar receta
              ElevatedButton.icon(
                onPressed: () {
                  // Acción al presionar el botón
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddRecipePage()),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text("Agregar Receta"),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Página para agregar recetas (puedes personalizarla)
