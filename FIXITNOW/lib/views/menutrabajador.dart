import 'package:flutter/material.dart';
import 'package:FIXITNOW/main.dart';

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
        body: Center( // Centra el contenido
          child: Column(
            mainAxisSize: MainAxisSize.min, // Ajusta el tamaño mínimo necesario para los botones
            children: [
              // Botón "Perfil"
              MenuButton(text: 'PERFIL'),
              const SizedBox(height: 10), // Espacio entre botones
              
              // Botón "Clientes Aceptados"
              MenuButton(text: 'CLIENTES ACEPTADOS'),
              const SizedBox(height: 10), // Espacio entre botones
              
              // Botón "Calificaciones Obtenidas"
              MenuButton(text: 'CALIFICACIONES OBTENIDAS'),
              const SizedBox(height: 300), // Espacio adicional antes del botón "Salir"
              
              // Botón "Salir"
              // Botón "Salir"
              SizedBox(
                width: 400, // Tamaño del botón
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color.fromARGB(255, 60, 59, 59), backgroundColor: const Color.fromARGB(255, 167, 217, 242),
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
                    (Route<dynamic> route) => false,  // Elimina todas las rutas anteriores
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

  // ignore: prefer_const_constructors_in_immutables
  MenuButton({super.key, required this.text});

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
        onPressed: () {
          // Acción al presionar el botón
        },
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
