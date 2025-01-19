import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thecook/authentication/screen/login_screen.dart';
import 'package:thecook/screens/screen_navbar/slider_drawer/archive/archive.dart';
import 'package:thecook/screens/screen_navbar/slider_drawer/help/help.dart';
import 'package:thecook/screens/screen_navbar/slider_drawer/profile/screen/profile.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  final user = FirebaseAuth.instance.currentUser;
  final _firebaseFirestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getUserData(String? uid) async {
    if (uid == null) return null;
    try {
      DocumentSnapshot<Map<String, dynamic>> userData =
          await _firebaseFirestore.collection('user').doc(uid).get();
      return userData.data();
    } catch (e) {
      print('Error obteniendo datos del usuario: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: getUserData(user?.uid),
      builder: (context, snapshot) {
        final userData = snapshot.data;

        String displayName =
            userData?['name'] ?? user?.displayName ?? 'Nombre de usuario';
        String email = user?.email ?? 'Correo electrónico';
        String? photoUrl = userData?['photoURL'] ?? user?.photoURL;

        return Theme(
          data: Theme.of(context),
          child: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                UserAccountsDrawerHeader(
                  accountName: Text(
                    displayName,
                    style: const TextStyle(
                        fontSize: 20,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  accountEmail: Text(
                    email,
                    style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  currentAccountPicture: CircleAvatar(
                    backgroundImage:
                        photoUrl != null ? NetworkImage(photoUrl) : null,
                    child: photoUrl == null
                        ? const Icon(Icons.account_circle, size: 50)
                        : null,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.orange[900]!,
                        Colors.orange[800]!,
                        Colors.orange[400]!,
                      ],
                    ),
                  ),
                ),
                buildListTile(context, Icons.account_circle, 'Perfil',
                    const ProfileDrawer()),
                buildListTile(context, Icons.notification_add_rounded,
                    'Notificaciones', const ArchivePage()),
                buildListTile(context, Icons.work_history_rounded, 'Archivados',
                    const HelpPage()),
                const Divider(
                  height: 30,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
                buildListTile(context, Icons.logout_rounded, 'Salir', null,
                    onTap: () async {
                  try {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pop();
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                      (route) => false,
                    );
                  } catch (e) {
                    print('Error al cerrar sesión: $e');
                  }
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}

ListTile buildListTile(
    BuildContext context, IconData icon, String title, Widget? page,
    {Function()? onTap}) {
  return ListTile(
    leading: getIconWithShader(icon),
    title: buildTextStyle(title),
    onTap: onTap ??
        () {
          if (page != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => page),
            );
          }
        },
  );
}

Text buildTextStyle(String title) {
  return Text(
    title,
    style: const TextStyle(
        fontSize: 18,
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.bold,
        color: Colors.black),
  );
}

ShaderMask getIconWithShader(IconData icon) {
  return ShaderMask(
    shaderCallback: (Rect bounds) {
      return LinearGradient(
        colors: [
          Colors.orange[900]!,
          Colors.orange[800]!,
          Colors.orange[400]!,
        ],
      ).createShader(bounds);
    },
    child: Icon(icon, size: 30, color: Colors.white),
  );
}
