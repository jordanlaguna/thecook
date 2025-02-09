import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thecook/model/recipes_list.dart';
import 'package:thecook/widget/modal_recipes/modal.dart';
import 'package:intl/intl.dart';

class RecipeCard extends StatefulWidget {
  final Recipe recipe;

  const RecipeCard({
    required this.recipe,
    super.key,
  });

  @override
  _RecipeCardState createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  Future<bool> _isFavorite() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('favorites')
          .doc(userId)
          .collection('recipes')
          .doc(widget.recipe.recipeId)
          .get();
      return doc.exists;
    }
    return false;
  }

  void _toggleFavorite(String recipeId) async {
    try {
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('favorites')
            .doc(userId)
            .collection('recipes')
            .doc(recipeId)
            .get();

        if (doc.exists) {
          await FirebaseFirestore.instance
              .collection('favorites')
              .doc(userId)
              .collection('recipes')
              .doc(recipeId)
              .delete();
        } else {
          await FirebaseFirestore.instance
              .collection('favorites')
              .doc(userId)
              .collection('recipes')
              .doc(recipeId)
              .set({'isFavorite': true});
        }
        setState(() {});
      }
    } catch (e) {
      print('Error al alternar "Me gusta": $e');
    }
  }

  void _checkUserLike() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('likes')
          .doc(widget.recipe.recipeId)
          .collection('users')
          .doc(userId)
          .get();

      setState(() {
        widget.recipe.liked = doc.exists;
      });
    }
  }

  Stream<int> _getLikeCount() {
    return FirebaseFirestore.instance
        .collection('likes')
        .doc(widget.recipe.recipeId)
        .collection('users')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  void _toggleLike() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      print("Usuario no autenticado");
      return;
    }

    try {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('user').doc(userId).get();

      if (!userDoc.exists) {
        print("Error: Usuario no encontrado en Firestore.");
        return;
      }

      Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;
      if (userData == null) {
        print("Error: Datos del usuario no válidos.");
        return;
      }

      String userName = userData['name'] ?? 'Usuario desconocido';
      String userPhotoURL = userData['photoURL'] ?? '';

      if (userPhotoURL.isEmpty &&
          FirebaseAuth.instance.currentUser?.photoURL != null) {
        userPhotoURL = FirebaseAuth.instance.currentUser!.photoURL!;

        await FirebaseFirestore.instance.collection('user').doc(userId).update({
          'photoURL': userPhotoURL,
        });
        print("photoURL actualizado en Firestore.");
      }

      DocumentReference likeRef = FirebaseFirestore.instance
          .collection('likes')
          .doc(widget.recipe.recipeId)
          .collection('users')
          .doc(userId);

      DocumentSnapshot doc = await likeRef.get();

      if (doc.exists) {
        await likeRef.delete();
        print("Like eliminado.");
      } else {
        await likeRef.set({
          'liked': true,
          'timestamp': FieldValue.serverTimestamp(),
          'name': userName,
          'photoURL': userPhotoURL,
        });
        print("Like guardado con nombre: $userName y foto: $userPhotoURL.");
      }

      _checkUserLike();
    } catch (e) {
      print("Error en _toggleLike(): $e");
    }
  }

  void _showLikesDialog() async {
    List<Map<String, dynamic>> users = [];

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('likes')
          .doc(widget.recipe.recipeId)
          .collection('users')
          .get();

      for (var doc in snapshot.docs) {
        var userDoc = await FirebaseFirestore.instance
            .collection('user')
            .doc(doc.id)
            .get();

        if (userDoc.exists) {
          users.add({
            'name': userDoc['name'] ?? 'Usuario desconocido',
            'photoURL': userDoc['photoURL'] ?? '',
          });
        }
      }
    } catch (e) {
      print("Error al obtener la lista de likes: $e");
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Usuarios que le gustan",
          style: TextStyle(fontSize: 22, fontFamily: 'Montserrat'),
        ),
        content: users.isNotEmpty
            ? SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: users[index]['photoURL'].isNotEmpty
                            ? NetworkImage(users[index]['photoURL'])
                            : null,
                        child: users[index]['photoURL'].isEmpty
                            ? const Icon(Icons.person)
                            : null,
                      ),
                      title: Text(users[index]['name']),
                    );
                  },
                ),
              )
            : const Text("Nadie ha dado like todavía."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cerrar"),
          ),
        ],
      ),
    );
  }

  String _formatLikes(int likes) {
    if (likes >= 1000000) {
      return "${(likes / 1000000).toStringAsFixed(1)}M ";
    } else if (likes >= 1000) {
      return "${(likes / 1000).toStringAsFixed(1)}K ";
    } else {
      return "$likes ";
    }
  }

  @override
  void initState() {
    super.initState();
    _checkUserLike();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.recipe.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FutureBuilder<bool>(
                      future: _isFavorite(),
                      builder: (context, snapshot) {
                        bool isFavorite = snapshot.data ?? false;
                        return IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : Colors.grey,
                          ),
                          onPressed: () =>
                              _toggleFavorite(widget.recipe.recipeId),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        widget.recipe.liked
                            ? Icons.thumb_up
                            : Icons.thumb_up_alt_outlined,
                        color: widget.recipe.liked ? Colors.blue : Colors.grey,
                      ),
                      onPressed: _toggleLike,
                    ),
                    GestureDetector(
                      onTap: _showLikesDialog,
                      child: StreamBuilder<int>(
                        stream: _getLikeCount(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text("...");
                          }
                          String likeText = _formatLikes(snapshot.data ?? 0);
                          return Text(
                            likeText,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              decoration: TextDecoration.underline,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Por: ${widget.recipe.author}",
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontFamily: 'Montserrat',
                ),
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      backgroundColor: Colors.transparent,
                      child: Stack(
                        children: [
                          InteractiveViewer(
                            panEnabled: true,
                            boundaryMargin: EdgeInsets.all(8),
                            minScale: 0.5,
                            maxScale: 3.0,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CachedNetworkImage(
                                imageUrl: widget.recipe.imageUrl,
                                fit: BoxFit.contain,
                                placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) =>
                                    const Icon(
                                  Icons.broken_image,
                                  size: 150,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: IconButton(
                              icon: const Icon(Icons.close,
                                  color: Colors.white, size: 30),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: widget.recipe.imageUrl,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.broken_image,
                    size: 150,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Fecha: ${widget.recipe.date != null ? DateFormat("yyyy-MM-dd").format(widget.recipe.date!.toDate()) : 'Desconocida'}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  fontFamily: 'Montserrat',
                ),
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  builder: (BuildContext context) {
                    return RecipeDetailsModal(recipe: widget.recipe);
                  },
                );
              },
              child: const Text(
                'Ver receta',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                  fontFamily: "Montserrat",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
