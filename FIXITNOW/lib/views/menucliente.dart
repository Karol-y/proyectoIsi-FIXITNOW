import 'package:flutter/material.dart';
import 'package:FIXITNOW/main.dart';
//import 'package:FIXITNOW/views/menutrabajador.dart';

void main() {
  runApp(const MenuScreenClient());
}

class MenuScreenClient extends StatelessWidget {
  const MenuScreenClient({super.key});

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
             // MenuButton(text: 'PERFIL'),
              //const SizedBox(height: 10), // Espacio entre botones
              
              // Botón "Calificaciones Obtenidas"
              //MenuButton(text: 'SERVICIOS OBTENIDOS'),
              //const SizedBox(height: 300), // Espacio adicional antes del botón "Salir"
              
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

