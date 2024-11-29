/*import 'package:FIXITNOW/views/trabajadorperfil.dart';
import 'package:flutter/material.dart';
import 'package:FIXITNOW/main.dart'; // Importa la vista WorkerProfile

void main() {
  runApp(const MenuScreen());
}

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Menú'),
          actions: [
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                // Acción al presionar el icono del menú
                Navigator.pop(context); // Cerrar el diálogo
              },
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Botón "Perfil"
              MenuButton(
                text: 'PERFIL',
                onPressed: () {
                  // Navega a la vista WorkerProfile
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const WorkerProfile()),
                  );
                },
              ),
              const SizedBox(height: 10),

              // Botón "Clientes Aceptados"
              MenuButton(
                text: 'CLIENTES ACEPTADOS',
                onPressed: () {
                  // Implementa la acción correspondiente
                },
              ),
              const SizedBox(height: 10),

              // Botón "Calificaciones Obtenidas"
              MenuButton(
                text: 'CALIFICACIONES OBTENIDAS',
                onPressed: () {
                  // Implementa la acción correspondiente
                },
              ),
              const SizedBox(height: 300),

              // Botón "Salir"
              SizedBox(
                width: 400,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color.fromARGB(255, 60, 59, 59),
                    backgroundColor: const Color.fromARGB(255, 167, 217, 242),
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: const BorderSide(color: Color.fromARGB(255, 60, 108, 148)),
                    ),
                  ),
                  onPressed: () {
                    // Acción al presionar el botón de salir
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const ingresar()), // Redirige a la página de inicio de sesión
                      (Route<dynamic> route) => false, // Elimina todas las rutas anteriores
                    );
                  },
                  child: const Text('SALIR', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed; // Callback para definir la acción del botón

  // Constructor que acepta texto y una función de callback
  const MenuButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220, // Ancho del botón centrado
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: const Color.fromARGB(217, 68, 32, 112),
          backgroundColor: const Color.fromARGB(255, 125, 208, 246),
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: const BorderSide(color: Colors.black),
          ),
        ),
        onPressed: onPressed, // Ejecuta la acción del botón
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
*/