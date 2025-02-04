import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thecook/screens/screen_navbar/slider_drawer/notifications/controller/notification_controller.dart';

class NotificacionPage extends StatefulWidget {
  const NotificacionPage({super.key});

  @override
  State<NotificacionPage> createState() => _NotificacionPageState();
}

class _NotificacionPageState extends State<NotificacionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Notificaciones',
            style: TextStyle(color: Colors.white, fontFamily: 'Montserrat'),
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              colors: [
                Colors.orange[900]!,
                Colors.orange[800]!,
                Colors.orange[400]!,
              ],
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white, size: 35),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.orange[50]!,
              const Color.fromARGB(255, 242, 221, 190)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: FutureBuilder<List<NotificationController>>(
            future: NotificationController.getAllNotifications(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return const Center(
                  child: Text('Error al cargar notificaciones'),
                );
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No hay notificaciones aún'));
              }

              final notifications = snapshot.data!;
              return ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  String formattedDate = 'Desconocida';
                  if (notification.createdAt != null) {
                    try {
                      DateTime date =
                          (notification.createdAt as Timestamp).toDate();
                      formattedDate = DateFormat("yyyy-MM-dd").format(date);
                    } catch (e) {
                      print("Error al convertir fecha: $e");
                    }
                  }
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Ícono en lugar de imagen
                          const Icon(
                            Icons.notifications_active,
                            size: 50,
                            color: Colors.orange,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  notification.title,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat',
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  notification.message,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Montserrat',
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  "Fecha: $formattedDate",
                                  style: const TextStyle(
                                      fontSize: 12, fontFamily: 'Montserrat'),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
