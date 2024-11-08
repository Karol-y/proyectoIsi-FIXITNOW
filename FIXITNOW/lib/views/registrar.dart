import 'package:flutter/material.dart';
import 'package:FIXITNOW/views/clienteformulario.dart';
import 'package:FIXITNOW/views/trabajadorformulario.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: registrar(),  // Cambia aquí a la nueva clase
    );
  }
}

// ignore: camel_case_types
class registrar extends StatefulWidget {
  const registrar({super.key});

  @override
  State<registrar> createState() => _registrarState();
}

// ignore: camel_case_types
class _registrarState extends State<registrar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      body: Center(
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,  // Esto coloca el botón "Atrás" en la parte inferior
            children: [
              Column(  // Agrupamos los widgets en un Column
                children: [
                  // Logo de la App
                  Container(
                    margin: const EdgeInsets.only(bottom: 30),
                    child: Image.asset(
                      'imagen/logo.jpg',  // Ruta de la imagen
                      width: 180,
                      height: 180,
                      fit: BoxFit.contain,
                    ),
                  ),
                  // Botón de Cliente
                  CustomButton(
                    text: 'Cliente',
                    onPressed: () {
                      // Acción de Cliente
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ClienteFormulario()),  // Aquí se usa la clase LoginPage
                      );
                    },
                  ),
                  // Botón de Trabajador
                  CustomButton(
                    text: 'Trabajador',
                    onPressed: () {
                      // Acción de Trabajador
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const WorkerForm()),  // Aquí se usa la clase LoginPage
                      );
                    },
                  ),
                ],
              ),
              // Botón Atrás con fondo blanco
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: Colors.white,  // Fondo blanco
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: const BorderSide(color: Color(0xFF86C5F5)),  // Borde del color de los demás botones
                    ),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  onPressed: () {
                    Navigator.pop(context);  // Acción para volver a la pantalla anterior
                  },
                  child: const Text(
                    'Atrás',
                    style: TextStyle(
                      color: Color.fromARGB(255, 73, 149, 207),  // Texto azul
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget personalizado para botones
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12), backgroundColor: const Color(0xFF86C5F5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          textStyle: const TextStyle(fontSize: 18),
        ),
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}