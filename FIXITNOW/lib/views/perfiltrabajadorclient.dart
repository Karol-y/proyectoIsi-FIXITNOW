import 'package:FIXITNOW/views/comentarios.dart';
import 'package:flutter/material.dart';

class DriverProfilePage extends StatefulWidget {
  const DriverProfilePage({super.key});

  @override
  State<DriverProfilePage> createState() => _DriverProfilePageState();
}

class _DriverProfilePageState extends State<DriverProfilePage> {
  int _rating = 0; // Variable para almacenar la calificación seleccionada
  // ignore: unused_field
  String _opinion = ""; // Variable para almacenar el mensaje del usuario

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
                const Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(
                          'https://via.placeholder.com/150', // Imagen de perfil de ejemplo
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
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
                        Icon(Icons.verified_user, color: Colors.blue, size: 40),
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

                // Título de la sección de calificar al trabajador
                const Text(
                  "Calificar al trabajador",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Sistema de calificación con estrellas
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        onPressed: () {
                          setState(() {
                            _rating = index + 1; // Guarda la calificación seleccionada
                          });
                        },
                        icon: Icon(
                          index < _rating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 40,
                        ),
                      );
                    }),
                  ),
                ),
                TextField(
                  onChanged: (text) {
                    setState(() {
                      _opinion = text; // Guarda la opinión escrita
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Escribe aquí tu opinión...",
                  ),
                  maxLines: 3, // Número máximo de líneas permitidas
                ),
              ],
            ),

            // Botón alineado a la izquierda
            Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton(
                onPressed: () {
                  // Acción del botón
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ReviewsPage()),
                );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Colors.blue), // Borde azul opcional
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: const Text(
                  "Calificaciones y Opiniones",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blue, // Texto azul
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: DriverProfilePage(),
  ));
}
