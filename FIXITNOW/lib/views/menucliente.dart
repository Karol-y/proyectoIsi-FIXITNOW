/*import 'package:flutter/material.dart';
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
}*/

import 'package:FIXITNOW/views/clienteperfil.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MenuScreenClient(),
    );
  }
}

class MenuScreenClient extends StatelessWidget {
  const MenuScreenClient({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menú'),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Navigator.pop(context); // Acción del menú (opcional)
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MenuButton(
              text: 'PERFIL',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ClientProfilePage(
                      clientImage: '',
                      clientName: 'Nombre del Cliente',
                      phoneNumber: '123456789',
                      email: 'cliente@correo.com',
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 230),
            SizedBox(
              width: 400,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                  backgroundColor: const Color.fromARGB(255, 26, 95, 173),
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: const BorderSide(color: Color.fromARGB(255, 16, 74, 121)),
                  ),
                ),
                onPressed: () {
                  // Acción al presionar "Salir"
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const MyApp()), // Cambiar a tu pantalla inicial
                    (Route<dynamic> route) => false,
                  );
                },
                child: const Text(
                  'SALIR',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const MenuButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.blue,
          padding: const EdgeInsets.symmetric(vertical: 12.0),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
