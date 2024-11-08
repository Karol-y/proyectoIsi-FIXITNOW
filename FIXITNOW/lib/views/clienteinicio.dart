import 'package:flutter/material.dart';
import 'package:FIXITNOW/views/mensaje.dart';
import 'package:FIXITNOW/views/menucliente.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Worker List App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ClientHomePage(),
    );
  }
}

// ignore: camel_case_types
class ClientHomePage extends StatefulWidget {
  const ClientHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ClientHomePageState createState() => _ClientHomePageState();
}

// ignore: camel_case_types
class _ClientHomePageState extends State<ClientHomePage> {
  String _selectedFilter = 'Todos'; // Opción de filtro seleccionada
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // Acción del menú
             Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MenuScreenClient()), 
             );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            onPressed: () {
              // Acción del ícono de chat
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatScreen()),  // Aquí se usa la clase LoginPage
              );
            },
          )
        ],
        title: const Text('INICIO'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Barra de búsqueda con botón de filtro
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Colors.grey),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: _selectedFilter == 'Todos'
                                  ? 'Buscar'
                                  : 'Buscar en $_selectedFilter', // Muestra el filtro seleccionado
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Botón de filtro
                PopupMenuButton<String>(
                  icon: const Icon(Icons.filter_list, color: Colors.blue),
                  onSelected: (String result) {
                    setState(() {
                      _selectedFilter = result;
                      _searchController.text = ''; // Limpia el campo de búsqueda
                    });
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'Todos',
                      child: Text('Todos'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'Plomería',
                      child: Text('Plomería'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'Jardinería',
                      child: Text('Jardinería'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'Aire Acondicionado',
                      child: Text('Aire Acondicionado'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'Servicio Doméstico',
                      child: Text('Servicio Doméstico'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Lista de trabajadores basada en el filtro seleccionado
            Expanded(
              child: ListView(
                children: _getFilteredWorkers(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Método para obtener los trabajadores filtrados
  List<Widget> _getFilteredWorkers() {
    List<Map<String, String>> workers = [
      {'name': 'Nombre del Trabajador', 'service': 'PLOMERÍA'},
      {'name': 'Nombre del Trabajador', 'service': 'JARDINERÍA'},
      {'name': 'Nombre del Trabajador', 'service': 'AIRE ACONDICIONADO'},
      {'name': 'Nombre del Trabajador', 'service': 'SERVICIO DOMÉSTICO'},
    ];

    // Filtrar según el servicio seleccionado
    if (_selectedFilter != 'Todos') {
      workers = workers
          .where((worker) => worker['service'] == _selectedFilter.toUpperCase())
          .toList();
    }

    // Construir la lista de trabajadores
    return workers.map((worker) {
      return _buildWorkerTile(worker['name']!, worker['service']!);
    }).toList();
  }

  // Método para construir los elementos de la lista de trabajadores
  Widget _buildWorkerTile(String workerName, String service) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: Colors.cyanAccent,
        child: Icon(Icons.tag_faces, color: Colors.black),
      ),
      title: Text(workerName),
      subtitle: Text(service),
      onTap: () {
        // Acción al presionar el trabajador
        print('$workerName seleccionado');
      },
    );
  }
}