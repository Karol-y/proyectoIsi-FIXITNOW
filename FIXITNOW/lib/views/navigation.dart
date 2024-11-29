/*import 'package:FIXITNOW/views/clienteinicio.dart';
import 'package:FIXITNOW/views/mensaje.dart';
import 'package:FIXITNOW/views/trabajadorinicio.dart';
import 'package:FIXITNOW/views/trabajadorperfil.dart';
import 'package:flutter/material.dart';
//import 'package:curved_navigation_bar/curved_navigation_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _pageIndex = 1;

  // Determinar el tipo de usuario
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    // Lógica para determinar la vista inicial
    final String userType = getUserType(); // Suponiendo que se obtiene de un método o servicio
    _pages = userType == 'cliente'
        ? [
            const Center(child: Text("Profile", style: TextStyle(fontSize: 24))),
            //const ClientHomePage(),
            ChatScreen(),
          ]
        : [
            const WorkerProfile(),
            const WorkerHomePage(),
           ChatScreen(),
          ];
  }

  // Simulación de un método para obtener el tipo de usuario
  String getUserType() {
    return 'trabajador'; // Esto puede ser dinámico dependiendo de tu lógica de autenticación
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.grey[200]!,
        color: Colors.blue,
        buttonBackgroundColor: const Color.fromARGB(255, 152, 210, 249),
        height: 57,
        items: const <Widget>[
          Icon(Icons.person, size: 25, color: Colors.white),
          Icon(Icons.home, size: 25, color: Colors.white),
          Icon(Icons.message_rounded, size: 25, color: Colors.white),
        ],
        onTap: (index) {
          setState(() {
            _pageIndex = index;
          });
        },
        animationDuration: const Duration(milliseconds: 300),
        animationCurve: Curves.easeInOut,
      ),
      body: _pages[_pageIndex],
    );
  }
}*/

import 'package:FIXITNOW/views/clienteinicio.dart';
import 'package:FIXITNOW/views/clienteperfil.dart';
import 'package:FIXITNOW/views/mensaje.dart';
import 'package:FIXITNOW/views/trabajadorinicio.dart';
import 'package:FIXITNOW/views/trabajadorperfil.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(tipo: '', numDoc: ''),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final String tipo;
  final String numDoc;

  const HomeScreen({
    super.key,
    required this.tipo,
    required this.numDoc,
  });

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _pageIndex = 0; // Mostrar la pantalla Inicio al iniciar
  late final List<Widget> _pages;
  late final String _tipo;
  late final String _numDoc;

  @override
  void initState() {
    super.initState();

    // Almacenar los valores recibidos en variables privadas
    _tipo = 'cliente';
    _numDoc = widget.numDoc;

    // Configurar las páginas basadas en el tipo de usuario
    _pages = _tipo == 'cliente'
        ? [
            ClientHomePage(numDoc: _numDoc), // Pasar numDoc a ClientHomePage
            const ClientProfilePage(clientImage: '', clientName: '', phoneNumber: '', email: '',),
            ChatScreen(),
          ]
        : [
            WorkerHomePage(numDoc: _numDoc), // Pasar numDoc a WorkerHomePage
            const WorkerProfile(),
            ChatScreen(),
          ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.grey[200]!,
        color: Colors.blue,
        buttonBackgroundColor: const Color.fromARGB(255, 152, 210, 249),
        height: 57,
        items: const <Widget>[
          Icon(Icons.home, size: 25, color: Colors.white),
          Icon(Icons.person, size: 25, color: Colors.white),
          Icon(Icons.message_rounded, size: 25, color: Colors.white),
        ],
        onTap: (index) {
          setState(() {
            _pageIndex = index;
          });
        },
        animationDuration: const Duration(milliseconds: 300),
        animationCurve: Curves.easeInOut,
      ),
      body: _pages[_pageIndex],
    );
  }
}
