import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:FIXITNOW/views/comentarios.dart';

class WorkerProfile extends StatefulWidget {
  const WorkerProfile({super.key});

  @override
  State<WorkerProfile> createState() => _WorkerProfileState();
}

class _WorkerProfileState extends State<WorkerProfile> {
  File? _profileImage;

  Future<void> _updateProfileImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: () {
            Navigator.pop(context); // Regresa a la vista anterior
          },
        ),
        title: const Text(
          "Perfil del Trabajador",
          style: TextStyle(
            color: Color.fromARGB(250, 70, 160, 239),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 254, 254),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Contenido principal
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Foto de perfil y nombre del trabajador
                Center(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: _updateProfileImage,
                        child: CircleAvatar(
                          radius: 40,
                          backgroundImage: _profileImage != null
                              ? FileImage(_profileImage!)
                              : const NetworkImage(
                                  'https://via.placeholder.com/150',
                                ) as ImageProvider,
                          child: _profileImage == null
                              ? const Icon(Icons.camera_alt,
                                  size: 40, color: Colors.white)
                              : null,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "PEDRO DAVID",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Ícono centrado con calificación y título
                const Center(
                  child: Column(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 48),
                      SizedBox(height: 8),
                      Text(
                        "4.91",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Calificación",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Sección de verificación de seguridad
                const Text(
                  "Verificación de seguridad",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Conoce los procesos de seguridad de los trabajadores",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Icon(Icons.verified_user,
                            color: Colors.blue, size: 40),
                        SizedBox(height: 8),
                        Text(
                          "Verificación\n de identidad",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Icon(Icons.shield, color: Colors.blue, size: 40),
                        SizedBox(height: 8),
                        Text(
                          "Libre de\n antecedentes",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Icon(Icons.workspace_premium,
                            color: Colors.blue, size: 40),
                        SizedBox(height: 8),
                        Text(
                          "Certificación\n del servicio",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Botón de calificaciones y opiniones
                Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ReviewsPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Colors.blue),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                    ),
                    child: const Text(
                      "Calificaciones y Opiniones",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: WorkerProfile(),
  ));
}
