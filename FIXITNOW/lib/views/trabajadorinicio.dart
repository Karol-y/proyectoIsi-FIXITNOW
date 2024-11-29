/*import 'package:flutter/material.dart';
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
}*/
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:FIXITNOW/views/mensaje.dart';
import 'package:FIXITNOW/views/menutrabajador.dart';

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
  _WorkerHomePageState createState() => _WorkerHomePageState();
}

class _WorkerHomePageState extends State<WorkerHomePage> {
  File? _image; // Variable para almacenar la imagen seleccionada.
  final ImagePicker _picker = ImagePicker();

  // Variable booleana para el estado activo/inactivo
  bool _isActive = true; // Su valor puede cambiar según los datos de la base de datos.

  // Método para alternar el estado de _isActive
  void _toggleActiveState() {
    setState(() {
      _isActive = !_isActive; // Alterna entre true y false
    });
  }

  // Método para seleccionar una imagen de la galería.
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Lista de servicios simulada con fecha y hora agregadas
  final List<Map<String, String>> _services = [
    {
      "foto": "https://via.placeholder.com/150", // URL de ejemplo
      "nombre": "Cliente 1",
      "contacto": "555-1234",
      "fecha": "27/11/2024",
      "hora": "14:00",
    },
    {
      "foto": "https://via.placeholder.com/150", // URL de ejemplo
      "nombre": "Cliente 2",
      "contacto": "555-5678",
      "fecha": "28/11/2024",
      "hora": "10:30",
    },
    {
      "foto": "https://via.placeholder.com/150", // URL de ejemplo
      "nombre": "Cliente 3",
      "contacto": "555-9101",
      "fecha": "29/11/2024",
      "hora": "16:00",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => const MenuScreen()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatScreen()),
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
              onTap: _pickImage,
              child: Row(
                children: [
                  _image != null
                      ? CircleAvatar(
                          radius: 30,
                          backgroundImage: FileImage(_image!),
                        )
                      : const CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.blue,
                          child: Icon(
                            Icons.camera_alt,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: _toggleActiveState, // Alternar estado al hacer clic
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Nombre del Trabajador',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          _isActive ? 'Activo' : 'Inactivo', // Estado dinámico
                          style: TextStyle(
                            color: _isActive ? Colors.green : Colors.red, // Color dinámico
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Servicios',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 15),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: _services.length,
                itemBuilder: (context, index) {
                  final service = _services[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          // Foto del cliente
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(service["foto"]!),
                          ),
                          const SizedBox(width: 10),
                          // Información del cliente
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  service["nombre"]!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  service["contacto"]!,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Fecha: ${service["fecha"]!}",
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        Text(
                                          "Hora: ${service["hora"]!}",
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                    // Botones debajo de fecha y hora
                                    Row(
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            // Acción para el botón verde
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                            minimumSize: const Size(30, 30), // Tamaño reducido
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                          ),
                                          child: const Icon(Icons.check, size: 16, color: Colors.white),
                                        ),
                                        const SizedBox(width: 5),
                                        ElevatedButton(
                                          onPressed: () {
                                            // Acción para el botón rojo
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                            minimumSize: const Size(30, 30), // Tamaño reducido
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                          ),
                                          child: const Icon(Icons.close, size: 16, color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
