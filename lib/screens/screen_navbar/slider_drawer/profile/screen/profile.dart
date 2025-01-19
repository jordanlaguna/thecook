// ignore_for_file: use_super_parameters, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickalert/quickalert.dart';
import 'package:icons_plus/icons_plus.dart';
import 'dart:io';
import 'package:thecook/screens/screen_navbar/slider_drawer/profile/controller/profile_controller.dart';
import 'package:thecook/screens/screen_navbar/slider_drawer/profile/services/image_services.dart';

class ProfileDrawer extends StatefulWidget {
  const ProfileDrawer({Key? key}) : super(key: key);

  @override
  State<ProfileDrawer> createState() => _ProfileDrawerState();
}

class _ProfileDrawerState extends State<ProfileDrawer> {
  final ProfileController _controller = ProfileController();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _identificationController =
      TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _telephoneController = TextEditingController();

  final List<String> items = ['Masculino', 'Femenino'];
  String? selectedValue;
  File? _imageFile;
  String? profileImageUrl;

  @override
  void initState() {
    super.initState();
    _controller.loadUserInfo(
      fullNameController: _fullNameController,
      emailController: _emailController,
      identificationController: _identificationController,
      dateController: _dateController,
      addressController: _addressController,
      telephoneController: _telephoneController,
      onGenderLoaded: (gender) => setState(() => selectedValue = gender),
      onImageLoaded: (imageUrl) => setState(() => profileImageUrl = imageUrl),
    );
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Perfil',
          style: TextStyle(color: Colors.white, fontFamily: "Montserrat"),
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
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_rounded),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                if (_imageFile != null) {
                  String? imageUrl =
                      await ImageService.uploadImage(_imageFile!);
                  if (imageUrl != null) {
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.success,
                      text: '¡Imagen de perfil actualizada!',
                      autoCloseDuration: const Duration(seconds: 3),
                      showConfirmBtn: false,
                    );
                  }
                }
                await _controller.saveProfileData(
                  context: context,
                  fullName: _fullNameController.text,
                  email: _emailController.text,
                  identification: _identificationController.text,
                  date: _dateController.text,
                  address: _addressController.text,
                  telephone: _telephoneController.text,
                  gender: selectedValue ?? '',
                );
              } else {
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.error,
                  text: 'Por favor completa todos los campos',
                  autoCloseDuration: const Duration(seconds: 3),
                  showConfirmBtn: false,
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.camera_alt),
            onPressed: _pickImage,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              profileImageUrl != null
                  ? CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(profileImageUrl!),
                    )
                  : _imageFile != null
                      ? CircleAvatar(
                          radius: 60,
                          backgroundImage: FileImage(_imageFile!),
                        )
                      : CircleAvatar(
                          radius: 60,
                          child: Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.orange[900],
                          ),
                        ),
              const SizedBox(height: 15),
              _buildTextField(_identificationController, 'Ingrese su cédula',
                  FontAwesome.id_card, '000000000'),
              const SizedBox(height: 15),
              _buildTextField(
                  _fullNameController,
                  'Ingrese su nombre completo',
                  FontAwesome.circle_user,
                  enabled: false,
                  'Nombre completo'),
              const SizedBox(height: 15),
              _buildDropdown(),
              const SizedBox(height: 15),
              _buildTextField(
                _emailController,
                'Ingrese su correo',
                FontAwesome.envelope,
                'ejemplousuario@gmail.com',
                enabled: false,
              ),
              const SizedBox(height: 15),
              _buildTextField(_dateController, 'Ingrese su fecha de nacimiento',
                  FontAwesome.calendar_xmark, 'dd/mm/aaaa'),
              const SizedBox(height: 15),
              _buildTextField(
                  _addressController,
                  'Ingrese su dirección completa',
                  FontAwesome.location_dot,
                  'Provincia/Cantón/Distrito'),
              const SizedBox(height: 15),
              _buildTextField(
                  _telephoneController,
                  'Ingrese su número de teléfono',
                  FontAwesome.phone,
                  '00000000'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      IconData icon, String hint,
      {bool enabled = true}) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        suffixIcon: Icon(icon, color: Colors.orange[900]),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
      validator: (value) =>
          value == null || value.isEmpty ? 'Este campo es obligatorio' : null,
    );
  }

  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      items: items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (newValue) => setState(() => selectedValue = newValue),
      decoration: InputDecoration(
        labelText: 'Género',
        suffixIcon: Icon(FontAwesome.venus_mars, color: Colors.orange[900]),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
      validator: (value) =>
          value == null || value.isEmpty ? 'Seleccione un género' : null,
    );
  }
}
