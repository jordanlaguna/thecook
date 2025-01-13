import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:thecook/screens/screen_navbar/slider_drawer/profile/services/image_services.dart';

class ProfileController {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  File? imageUpload;
  Map<String, String> initialValues = {};

  Future<void> loadUserInfo({
    required TextEditingController fullNameController,
    required TextEditingController emailController,
    required TextEditingController identificationController,
    required TextEditingController dateController,
    required TextEditingController addressController,
    required TextEditingController telephoneController,
    required Function(String?) onGenderLoaded,
    required Function(String?) onImageLoaded,
  }) async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userInfo =
          await _firebaseFirestore.collection('user').doc(user.uid).get();

      if (userInfo.exists) {
        final data = userInfo.data() as Map<String, dynamic>;
        fullNameController.text = data['name'] ?? user.displayName ?? '';
        emailController.text = data['email'] ?? user.email ?? '';
        identificationController.text = data['identification'] ?? '';
        dateController.text = data['date'] ?? '';
        addressController.text = data['address'] ?? '';
        telephoneController.text = data['phone'] ?? '';
        onGenderLoaded(data['gender']);
        onImageLoaded(data['profileImage']);
      }
    }
  }

  bool hasChanges(
      {required TextEditingController fullNameController,
      required TextEditingController emailController,
      required TextEditingController identificationController,
      required TextEditingController dateController,
      required TextEditingController addressController,
      required TextEditingController telephoneController,
      required String? selectedGender}) {
    return fullNameController.text != initialValues['fullName'] ||
        emailController.text != initialValues['email'] ||
        identificationController.text != initialValues['identification'] ||
        dateController.text != initialValues['date'] ||
        addressController.text != initialValues['address'] ||
        telephoneController.text != initialValues['telephone'] ||
        (selectedGender ?? '') != initialValues['gender'] ||
        imageUpload != null;
  }

  Future<void> saveProfileData(
      {required BuildContext context,
      required String fullName,
      required String email,
      required String identification,
      required String date,
      required String address,
      required String telephone,
      required String gender}) async {
    String uid = _auth.currentUser!.uid;

    Map<String, dynamic> userData = {
      'name': fullName,
      'email': email,
      'identification': identification,
      'gender': gender,
      'date': date,
      'address': address,
      'phone': telephone,
    };

    try {
      await _firebaseFirestore.collection('user').doc(uid).update(userData);
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: '¡Datos actualizados correctamente!',
        autoCloseDuration: const Duration(seconds: 2),
        showConfirmBtn: false,
      );
    } catch (e) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: 'Error al actualizar los datos.',
        autoCloseDuration: const Duration(seconds: 2),
        showConfirmBtn: false,
      );
    }
  }

  Future<void> uploadProfileImage(BuildContext context) async {
    if (imageUpload != null) {
      try {
        // Subimos la imagen a Firebase Storage
        String? imageUrl = await ImageService.uploadImage(imageUpload!);

        if (imageUrl != null) {
          String uid = _auth.currentUser!.uid;

          // Guardamos la URL de la imagen en Firestore
          await _firebaseFirestore.collection('user').doc(uid).update({
            'photoURL': imageUrl,
          });

          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            text: '¡Foto de perfil actualizada!',
            autoCloseDuration: const Duration(seconds: 2),
            showConfirmBtn: false,
          );

          imageUpload = null;
        } else {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            text: 'Error al subir la imagen.',
            autoCloseDuration: const Duration(seconds: 2),
            showConfirmBtn: false,
          );
        }
      } catch (e) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: 'Error al actualizar la foto de perfil.',
          autoCloseDuration: const Duration(seconds: 2),
          showConfirmBtn: false,
        );
      }
    }
  }
}
