// ignore_for_file: use_super_parameters

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:thecook/screens/bottom_navigator_bar/favorite_page/favorite.dart';
import 'package:thecook/screens/bottom_navigator_bar/home_page/home.dart';
import 'package:thecook/screens/bottom_navigator_bar/profile_page/screen/profile.dart';
import 'package:thecook/screens/bottom_navigator_bar/settings_page/settings.dart';
import 'package:thecook/screens/screen_navbar/navbar/navbar.dart';

void main() {
  runApp(const HomeModule());
}

class HomeModule extends StatefulWidget {
  const HomeModule({Key? key}) : super(key: key);

  @override
  State<HomeModule> createState() => _ModuleMainState();
}

class _ModuleMainState extends State<HomeModule> {
  int index = 0;
  final List<Widget> screens = [
    const HomePage(),
    const FavoritePage(),
    const ProfilePage(),
    const SettingsPage(),
  ];

  List<Widget>? _getActionsForPage(int index) {
    if (index == 3) {}
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final items = [
      const Icon(
        Icons.home,
        color: Colors.white,
        size: 35,
      ),
      const Icon(
        Icons.favorite,
        color: Colors.white,
        size: 35,
      ),
      const Icon(Icons.account_circle, color: Colors.white, size: 35),
      const Icon(Icons.settings, color: Colors.white, size: 35),
    ];
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.blue[50],
        drawer: const NavBar(),
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
              gradient: LinearGradient(begin: Alignment.topCenter, colors: [
                Colors.orange[900]!,
                Colors.orange[800]!,
                Colors.orange[400]!,
              ]),
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.white, size: 35),
          actions: _getActionsForPage(index),
        ),
        body: screens.elementAt(index),
        bottomNavigationBar: CurvedNavigationBar(
          color: Colors.orange[900]!,
          backgroundColor: Colors.white,
          items: items,
          height: 65,
          index: index,
          onTap: (newIndex) {
            setState(() {
              index = newIndex % screens.length;
            });
          },
        ),
      ),
    );
  }
}
