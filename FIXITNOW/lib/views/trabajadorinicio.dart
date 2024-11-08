import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:FIXITNOW/views/mensaje.dart';
import 'package:FIXITNOW/views/menutrabajador.dart'; // Necesario para manejar archivos.

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Worker App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WorkerHomePage(),
    );
  }
}

class WorkerHomePage extends StatefulWidget {
  const WorkerHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _WorkerHomePageState createState() => _WorkerHomePageState();
}

class _WorkerHomePageState extends State<WorkerHomePage> {
  File? _image; // Variable para almacenar la imagen seleccionada.
  final ImagePicker _picker = ImagePicker();

  // Método para seleccionar una imagen de la galería.
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // Aquí puedes agregar la acción para el menú
            // ignore: avoid_print
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MenuScreen()),  // Aquí se usa la clase LoginPage
              );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            onPressed: () {
              // Aquí puedes agregar la acción para el ícono de mensaje
              // ignore: avoid_print
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatScreen()),  // Aquí se usa la clase LoginPage
              );
            },
          )
        ],
        title: const Text('Inicio'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: _pickImage, // Al tocar el avatar, se abre la galería.
              child: Row(
                children: [
                  _image != null
                      ? CircleAvatar(
                          radius: 30,
                          backgroundImage: FileImage(_image!), // Mostrar la imagen seleccionada.
                        )
                      : const CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.blue, // Fondo azul cuando no hay imagen
                          child: Icon(
                            Icons.camera_alt,
                            size: 30,
                            color: Colors.white, // Ícono blanco
                          ),
                        ),
                  const SizedBox(width: 10),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nombre del Trabajador',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '(ACTIVO)',
                        style: TextStyle(color: Colors.green),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Texto que reemplaza la "Descripción" y "Servicio que ofrece" con el mismo estilo
            const Text(
              'Servicio que Ofrece',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Descripción...',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            const Divider(),
            const ListTile(
              leading: Icon(Icons.person_outline),
              title: Text('(Nombre del Cliente)'),
              subtitle: Text('Requiere de tu servicio'),
            ),
            const ListTile(
              leading: Icon(Icons.person_outline),
              title: Text('(Nombre del Cliente)'),
              subtitle: Text('Ha calificado tu servicio'),
            ),
          ],
        ),
      ),
    );
  }
}