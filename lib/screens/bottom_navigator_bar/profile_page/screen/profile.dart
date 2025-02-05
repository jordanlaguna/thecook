import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thecook/screens/bottom_navigator_bar/profile_page/controller/profile_controller.dart';
import 'package:thecook/screens/add_recipes/screen/add_recipes.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileController _profileController = ProfileController();
  final User? _user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final String uid = _user?.uid ?? '';

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 40.0, left: 16.0, right: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  _showFullImageDialog(context, uid);
                },
                child: CircleAvatar(
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
                        future: _profileController.getUserPhotoURL(uid),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }
                          if (snapshot.hasError) {
                            return const Icon(Icons.error);
                          } else {
                            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                              return Image.network(
                                snapshot.data!,
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
              ),
              const SizedBox(height: 20),
              FutureBuilder<Map<String, dynamic>>(
                future: _profileController.getUserData(uid),
                builder: (BuildContext context,
                    AsyncSnapshot<Map<String, dynamic>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Text("Error al cargar los datos");
                  }
                  if (snapshot.hasData && snapshot.data != null) {
                    Map<String, dynamic> userData = snapshot.data!;
                    String userName = userData['name'] ??
                        _user?.displayName ??
                        'Nombre no disponible';

                    return Column(
                      children: [
                        Text(
                          userName,
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const Text("Usuario no encontrado");
                  }
                },
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddRecipePage(),
                    ),
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

  void _showFullImageDialog(BuildContext context, String uid) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: FutureBuilder<String?>(
            future: _profileController.getUserPhotoURL(uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError ||
                  !snapshot.hasData ||
                  snapshot.data!.isEmpty) {
                return const Icon(Icons.error, size: 100, color: Colors.red);
              }
              return ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  snapshot.data!,
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
