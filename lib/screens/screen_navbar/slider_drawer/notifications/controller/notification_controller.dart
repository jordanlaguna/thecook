import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationController {
  final String title;
  final String message;
  final Timestamp? createdAt;
  final String uid;

  NotificationController({
    required this.title,
    required this.message,
    this.createdAt,
    required this.uid,
  });

  // Método para obtener notificaciones excluyendo las del usuario actual
  static Future<List<NotificationController>> getAllNotifications() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final FirebaseAuth auth = FirebaseAuth.instance;

    final String? currentUserUid = auth.currentUser?.uid;

    if (currentUserUid == null) {
      return [];
    }

    final QuerySnapshot<Map<String, dynamic>> snapshot =
        await firestore.collection('notifications').get();

    return snapshot.docs
        .map((doc) {
          final data = doc.data();
          return NotificationController(
            title: data['title'] ?? '',
            message: data['message'] ?? 'Message unknown',
            createdAt: data['createdAt'] as Timestamp?,
            uid: data['userId'] ?? '',
          );
        })
        .where((notification) => notification.uid != currentUserUid)
        .toList();
  }
}
