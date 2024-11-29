/*import 'package:FIXITNOW/views/comentarios.dart';
import 'package:flutter/material.dart';
import 'package:FIXITNOW/controllers/controlador_api.dart';

class DriverProfilePage extends StatefulWidget {
  final String workerImage;
  final String workerName;
  final String clienteId;
  final String trabajadorId;

  const DriverProfilePage({
    super.key,
    required this.workerImage,
    required this.workerName,
    required this.clienteId,
    required this.trabajadorId,
  });

  @override
  State<DriverProfilePage> createState() => _DriverProfilePageState();
}

class _DriverProfilePageState extends State<DriverProfilePage> {
  int _rating = 0; // Variable para almacenar la calificación seleccionada
  // ignore: unused_field
  String _opinion = ""; // Variable para almacenar el mensaje del usuario
  String clienteId = "";
  String trabajadorId= "";
  final ControladorAPI _controladorAPI = ControladorAPI();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: () {
            Navigator.pop(context); // Regresa a la vista anterior
          },
        ),
        title: const Text(
          "Perfil del Trabajador",
          style: TextStyle(
            color: Color.fromARGB(250, 70, 160, 239),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 254, 254),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Contenido principal
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Foto de perfil y nombre del trabajador
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey,
                          backgroundImage: widget.workerImage.isNotEmpty                
                            ? NetworkImage(widget.workerImage) // URL de la imagen
                            : null, // Fondo gris si no hay imagen
                          child: widget.workerImage.isEmpty
                            ? const Icon(Icons.person, color: Colors.white)
                            : null,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          widget.workerName.isNotEmpty ? widget.workerName : "Nombre no disponible",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Ícono centrado con calificación y título
                  const Center(
                    child: Column(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 48),
                        SizedBox(height: 8),
                        Text(
                          "4.91",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Calificación",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Sección de verificación de seguridad
                  const Text(
                    "Verificación de seguridad",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Conoce los procesos de seguridad de los trabajadores",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Icon(Icons.verified_user, color: Colors.blue, size: 40),
                          SizedBox(height: 8),
                          Text(
                            "Verificación\n de identidad",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Icon(Icons.shield, color: Colors.blue, size: 40),
                          SizedBox(height: 8),
                          Text(
                            "Libre de\n antecedentes",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Icon(Icons.workspace_premium,
                              color: Colors.blue, size: 40),
                          SizedBox(height: 8),
                          Text(
                            "Certificación\n del servicio",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Título de la sección de calificar al trabajador
                  const Text(
                    "Calificar al trabajador",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Sistema de calificación con estrellas
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return IconButton(
                          onPressed: () {
                            setState(() {
                              _rating = index + 1; // Guarda la calificación seleccionada
                            });
                          },
                          icon: Icon(
                            index < _rating ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                            size: 40,
                          ),
                        );
                      }),
                    ),
                  ),
                  TextField(
                    onChanged: (text) {
                      setState(() {
                        _opinion = text; // Guarda la opinión escrita
                      });
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Escribe aquí tu opinión...",
                    ),
                    maxLines: 3, // Número máximo de líneas permitidas
                  ),
                ],
              ),

              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    //Acción para enviar datos al controlador
                    if(_rating == 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Por favor, selecciona una calificación")),
                      );
                      return;
                    }
                    if(_opinion.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Por favor, escribe tu opinión")),
                      );
                      return;
                    }
                   
                    //llamar al controlador para enviar datos
                    _controladorAPI.enviarCalificacionOpinion(
                      trabajadorId: widget.trabajadorId,
                      clienteId: widget.clienteId,
                      rating: _rating, 
                      opinion: _opinion.trim(),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Calificación enviada con éxito")),
                    );
                    //limpia los campos después de enviar
                    setState(() {
                      _rating = 0;
                      _opinion = " ";
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: const Text(
                    "Enviar calificación",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              // Botón alineado a la izquierda
              Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton(
                  onPressed: () {
                    // Acción del botón
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ReviewsPage(trabajadorId: widget.trabajadorId)),
                  );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Colors.blue), // Borde azul opcional
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: const Text(
                    "Calificaciones y Opiniones",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue, // Texto azul
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

void main() {
  runApp(const MaterialApp(
    home: DriverProfilePage(
      workerImage: '',
      workerName: '',
      clienteId: '',
      trabajadorId: '',
    ),
  ));
}*/

import 'package:FIXITNOW/views/comentarios.dart';
import 'package:flutter/material.dart';
import 'package:FIXITNOW/controllers/controlador_api.dart';

class DriverProfilePage extends StatefulWidget {
  final String workerImage;
  final String workerName;
  final String clienteId;
  final String trabajadorId;

  const DriverProfilePage({
    super.key,
    required this.workerImage,
    required this.workerName,
    required this.clienteId,
    required this.trabajadorId,
  });

  @override
  State<DriverProfilePage> createState() => _DriverProfilePageState();
}

class _DriverProfilePageState extends State<DriverProfilePage> {
  int _rating = 0; // Variable para almacenar la calificación seleccionada
  String _opinion = ""; // Variable para almacenar el mensaje del usuario
  final TextEditingController _opinionController = TextEditingController(); // Controlador para el campo de texto
  final ControladorAPI _controladorAPI = ControladorAPI();

  @override
  void dispose() {
    _opinionController.dispose(); // Liberar recursos del controlador cuando el widget se destruye
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: () {
            Navigator.pop(context); // Regresa a la vista anterior
          },
        ),
        title: const Text(
          "Perfil del Trabajador",
          style: TextStyle(
            color: Color.fromARGB(250, 70, 160, 239),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 254, 254),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Foto de perfil y nombre del trabajador
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey,
                          backgroundImage: widget.workerImage.isNotEmpty
                              ? NetworkImage(widget.workerImage)
                              : null,
                          child: widget.workerImage.isEmpty
                              ? const Icon(Icons.person, color: Colors.white)
                              : null,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          widget.workerName.isNotEmpty
                              ? widget.workerName
                              : "Nombre no disponible",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Sistema de calificación con estrellas
                  const Text(
                    "Calificar al trabajador",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return IconButton(
                          onPressed: () {
                            setState(() {
                              _rating = index + 1; // Guarda la calificación seleccionada
                            });
                          },
                          icon: Icon(
                            index < _rating ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                            size: 40,
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Campo de texto con botón de enviar en la esquina inferior derecha
                  Stack(
                    children: [
                      TextField(
                        controller: _opinionController, // Asignar controlador al campo de texto
                        onChanged: (text) {
                          setState(() {
                            _opinion = text; // Guarda la opinión escrita
                          });
                        },
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: "Escribe aquí tu opinión...",
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                        ),
                        maxLines: 3,
                      ),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: IconButton(
                          onPressed: () {
                            if (_rating == 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "Por favor, selecciona una calificación")),
                              );
                              return;
                            }
                            if (_opinion.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text("Por favor, escribe tu opinión")),
                              );
                              return;
                            }

                            // Llamar al controlador para enviar datos
                            _controladorAPI.enviarCalificacionOpinion(
                              trabajadorId: widget.trabajadorId,
                              clienteId: widget.clienteId,
                              rating: _rating,
                              opinion: _opinion.trim(),
                            );

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      "Calificación enviada con éxito")),
                            );

                            // Limpiar los campos después de enviar
                            setState(() {
                              _rating = 0;
                              _opinion = "";
                              _opinionController.clear(); // Limpia el campo de texto
                            });
                          },
                          icon: const Icon(
                            Icons.send,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ReviewsPage(
                              trabajadorId: widget.trabajadorId)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Colors.blue),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                  ),
                  child: const Text(
                    "Calificaciones y Opiniones",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue,
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

void main() {
  runApp(const MaterialApp(
    home: DriverProfilePage(
      workerImage: '',
      workerName: '',
      clienteId: '',
      trabajadorId: '',
    ),
  ));
}
