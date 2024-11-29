/*import 'package:flutter/material.dart';
import 'package:FIXITNOW/views/clienteinicio.dart';
import 'package:FIXITNOW/views/trabajadorinicio.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),  // Página de inicio de sesión
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  Future<void> loginUser(BuildContext context, String usuario, String contrasena) async {
    const urlString = 'http://192.168.0.24/apis/api2.php';
    final uri = Uri.parse(urlString);
    
    final response = await http.post(uri, body:{
      'usuario': usuario,
      'contrasena': contrasena,
    },);

    if(response.statusCode == 200) {
      //autenticacion exitosa
      final data = jsonDecode(response.body);
      if(data['success']) {
        final tipo = data['tipo'];
        final numDoc = data['numDoc']; //num de identidad del cliente, si este inicia la sesion
      
        if (tipo == 'cliente') {
          print('Valor de numDoc antes de enviar a ClientHomePage: $numDoc');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ClientHomePage(numDoc: numDoc)),
            );
        } else if (tipo == 'trabajador'){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const WorkerHomePage()),
            );
        }
      }
    } else if(response.statusCode == 401) {
      //credenciales incorrectas
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Usuario o Contraseña incorrectos'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Aceptar'),
            ),
          ],
        ), 
      );
    } else if(response.statusCode == 400) {
      //datos faltantes
      showDialog(
        context: context, 
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Usuario o Contraseña faltante'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), 
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );
    } else {
      //error del servidor u otro error
      showDialog(
        context: context, 
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Error de conexión al servidor'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), 
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();  // Llave para el estado del formulario
    final TextEditingController _userController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();

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
          child: Form(
            key: _formKey,  // Asignamos la llave al formulario
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo de la App
                Container(
                  margin: const EdgeInsets.only(bottom: 30),
                  child: Image.asset(
                    'imagen/logo.jpg',  // Ruta de la imagen del logo
                    width: 180,
                    height: 180,
                    fit: BoxFit.contain,
                  ),
                ),
                // Campo de usuario
                TextFormField(
                  controller: _userController,
                  decoration: const InputDecoration(
                    labelText: 'Usuario',  // Etiqueta para el campo de usuario
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa el usuario';  // Mensaje de error
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),  // Espacio entre campos
                // Campo de contraseña
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,  // Ocultar texto para la contraseña
                  decoration: const InputDecoration(
                    labelText: 'Contraseña',  // Etiqueta para el campo de contraseña
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa la contraseña';  // Mensaje de error
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),  // Espacio entre el campo de contraseña y los botones
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Botón de Atrás
                    CustomButton(
                      text: 'Atrás',
                      onPressed: () {
                        // Acción del botón Atrás
                        Navigator.pop(context);  // Volver a la pantalla anterior
                      },
                      width: 100,  // Ajustar tamaño del botón
                    ),
                    // Botón de Ingresar
                    CustomButton(
                      text: 'Ingresar',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Si el formulario es válido, realiza la autenticación
                          loginUser(context, _userController.text, _passwordController.text);
                        }
                      },
                      width: 100,  // Ajustar tamaño del botón
                    ),
                  ],
                ),
              ],
            ),
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
  final double width;

  const CustomButton({super.key, required this.text, required this.onPressed, required this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,  // Personalizamos el ancho del botón
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
}*/

import 'package:FIXITNOW/views/navigation.dart';
import 'package:flutter/material.dart';
//import 'package:FIXITNOW/views/clienteinicio.dart';
//import 'package:FIXITNOW/views/trabajadorinicio.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(), // Página de inicio de sesión
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  Future<void> loginUser(BuildContext context, String usuario, String contrasena) async {
    const urlString = 'http://192.168.0.24/apis/api2.php';
    final uri = Uri.parse(urlString);

    final response = await http.post(
      uri,
      body: {
        'usuario': usuario,
        'contrasena': contrasena,
      },
    );

    if (response.statusCode == 200) {
      // Autenticación exitosa
      final data = jsonDecode(response.body);
      if (data['success']) {
        final tipo = data['tipo'];
        final numDoc = data['numDoc']; // Número de identidad del cliente

        // Navegar a HomeScreen con los parámetros `tipo` y `numDoc`
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(tipo: tipo, numDoc: numDoc),
          ),
        );
      }
    } else if (response.statusCode == 401) {
      // Credenciales incorrectas
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Usuario o Contraseña incorrectos'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );
    } else if (response.statusCode == 400) {
      // Datos faltantes
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Usuario o Contraseña faltante'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );
    } else {
      // Error del servidor u otro error
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Error de conexión al servidor'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController _userController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();

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
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 30),
                  child: Image.asset(
                    'imagen/logo.jpg',
                    width: 180,
                    height: 180,
                    fit: BoxFit.contain,
                  ),
                ),
                TextFormField(
                  controller: _userController,
                  decoration: const InputDecoration(
                    labelText: 'Usuario',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa el usuario';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Contraseña',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa la contraseña';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomButton(
                      text: 'Atrás',
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      width: 100,
                    ),
                    CustomButton(
                      text: 'Ingresar',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          loginUser(
                              context, _userController.text, _passwordController.text);
                        }
                      },
                      width: 100,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double width;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          backgroundColor: const Color(0xFF86C5F5),
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
