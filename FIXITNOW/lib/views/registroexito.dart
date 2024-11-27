/*import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, 
   
      home: Scaffold(
        appBar: AppBar(title: const Text('Ventana Emergente')),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              // Aquí llamamos a la función que mostrará el diálogo
              mostrarDialogoExitoso(context);
            },
            child: const Text('Mostrar mensaje'),
          ),
        ),
      ),
    );
  }

  void mostrarDialogoExitoso(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          backgroundColor: Colors.cyanAccent,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '¡El registro ha sido exitoso!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Cerrar el diálogo
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlueAccent, // Color del botón
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Aceptar'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}*/

import 'package:FIXITNOW/views/iniciosesion.dart';
import 'package:flutter/material.dart';

// Clase de utilidades para manejar los diálogos
class Registroexito {
  static void mostrarDialogoExitoso(BuildContext context, String mensaje) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          backgroundColor: const Color.fromARGB(255, 34, 165, 194),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  mensaje,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),  
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MyApp()),
                    );  // Redirigir a la pantalla de inicio
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 226, 234, 238), // Color del botón
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Aceptar'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
