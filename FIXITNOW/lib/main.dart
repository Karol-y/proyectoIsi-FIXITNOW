import 'package:flutter/material.dart';
import 'package:FIXITNOW/views/iniciosesion.dart';
import 'package:FIXITNOW/views/registrar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Main(),
    );
  }
}



  class Main extends StatelessWidget {
    const Main({super.key});

    @override
    Widget build(BuildContext context) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ingresar(),  // Cambia aquí a la nueva clase
      );
    }
  }

  // ignore: camel_case_types
  class ingresar extends StatefulWidget {
    const ingresar({super.key});

    @override
    State<ingresar> createState() => _ingresarState();
  }

  // ignore: camel_case_types
  class _ingresarState extends State<ingresar> {
    // Cambiar el nombre de HomePage a Ingresar
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
                // Botón de Iniciar Sesión
                CustomButton(
                  text: 'Iniciar Sesión',
                  onPressed: () {
                    // Acción de Iniciar Sesión
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),  // Aquí se usa la clase LoginPage
                    );
                  },
                ),
                // Botón de Registrarse
                CustomButton(
                  text: 'Registrarse',
                  onPressed: () {
                    // Acción de Registrarse
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const registrar()),  // Aquí se usa la clase LoginPage
                    );
                  },
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