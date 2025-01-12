import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

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
          padding: const EdgeInsets.only(top: 60.0, left: 16.0, right: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Foto de perfil
              CircleAvatar(
                radius: 80,
                backgroundImage: AssetImage('assets/profile_photo.png'),
                backgroundColor: Colors.grey[200],
              ),
              const SizedBox(height: 20),
              // Nombre del usuario
              const Text(
                'Nombre del Usuario',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              // Correo electrónico
              const Text(
                'correo@ejemplo.com',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
