import 'package:flutter/material.dart';
import 'package:FIXITNOW/views/mensaje.dart';
import 'package:FIXITNOW/views/menucliente.dart';
import 'package:FIXITNOW/views/solicitarservicio.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
                      value: 'Electricidad',
                      child: Text('Electricidad'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'Mecánica',
                      child: Text('Mecánica'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'Carpintería',
                      child: Text('Carpintería'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Lista de trabajadores basada en el filtro seleccionado
            Expanded(
              child: FutureBuilder<List<Widget>>(
                future: _getFilteredWorkers(),
                builder: (context, snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if(snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if(!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No se encontraron trabajadores.'));
                  } else {
                    return ListView(children: snapshot.data!);
                  }
                },
                //children: _getFilteredWorkers(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /* Método para reemplazar "localhost" por la dirección IP
  String _replaceLocalhostWithIP(String url) {
    return url.replaceAll('localhost', '192.168.0.24'); // Cambia por la IP de tu computadora
  }*/

  // Método para obtener los trabajadores filtrados desde la API
  Future<List<Widget>> _getFilteredWorkers() async {
  List<Widget> workerTiles = [];
    try {
      // URL base de la API
      String url = 'http://192.168.0.24/apis/buscar.php';

      // Agregar el filtro de servicio si no es 'Todos'
      if (_selectedFilter != 'Todos') {
        url += '?servicio=${_selectedFilter.toUpperCase()}';
      }

      // Realizar la solicitud GET
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Decodificar la respuesta JSON
        List<dynamic> workers = json.decode(response.body);

        if (workers.isEmpty) {
          // Respuesta vacía
          return [
            const Center(child: Text('No se encontraron trabajadores.')),
          ];
        }

        // Construir la lista de trabajadores
        workerTiles = workers.map((worker) {
          // Obtener y reemplazar la URL de la imagen si es necesario
          String imageUrl = worker['foto'] ?? '';  // O el campo que contiene la imagen
          return _buildWorkerTile(
            '${worker['nombres']} ${worker['apellidos']}',
            worker['tipSer'], // Asegúrate de incluir `tipSer` en la respuesta
            imageUrl,
            worker['email'], // Email del trabajador
            worker['telefono'], // Teléfono del trabajador
            worker['descripcion'], // Descripción del trabajador
        );
        }).toList();
      } else {
        throw Exception('Error al obtener los trabajadores: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al cargar los trabajadores: $e');
      workerTiles = [
        const Center(
          child: Text('No se pudieron cargar los trabajadores.'),
        ),
      ];
    }
    return workerTiles;
  }

  Widget _buildWorkerTile(
    String name, 
    String serviceType, 
    String imageUrl,
    String email,
    String phone,
    String description) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        contentPadding: const EdgeInsets.all(8),
        leading: imageUrl.isNotEmpty
            ? CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(imageUrl), //usando NetworkImage para cargar la URL
              )
            : const CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, color: Colors.white),
              ),
        title: Text(name),
        subtitle: Text(serviceType),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WorkerDetailsPage(
                workerImage: imageUrl,
                workerName: name, 
                serviceType: serviceType, 
                email: email,
                phoneNumber: phone,
                description: description,
              ),
            ),
          );
        },
      ),
    );
  }
}