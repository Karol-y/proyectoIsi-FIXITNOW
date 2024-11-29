/*import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Para formatear fechas y horas
import 'package:FIXITNOW/views/perfiltrabajadorclient.dart';

class WorkerDetailsPage extends StatefulWidget {
  final String workerImage;
  final String workerName;
  final String serviceType;
  final String description;
  final String phoneNumber;
  final String email;
  final String trabajadorId;
  final String clienteId;

  const WorkerDetailsPage({
    super.key,
    required this.workerImage,
    required this.workerName,
    required this.serviceType,
    required this.description,
    required this.phoneNumber,
    required this.email,
    required this.trabajadorId,
    required this.clienteId,
  });

  @override
  State<WorkerDetailsPage> createState() => _WorkerDetailsPageState();
}

class _WorkerDetailsPageState extends State<WorkerDetailsPage> {
  DateTime? _selectedDate; // Fecha seleccionada
  TimeOfDay? _selectedTime; // Hora seleccionada

  // Método para seleccionar la fecha
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(), // No permite fechas pasadas
      lastDate: DateTime.now().add(const Duration(days: 365)), // Permite hasta un año
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Método para seleccionar la hora
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  //Navegar a la vista de DriverProfilePage
  void _goToDriverProfilePage(BuildContext context, String image, String name, String clienteId, String trabajadorId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DriverProfilePage(
          workerImage: image,
          workerName: name,
          trabajadorId: trabajadorId,
          clienteId: clienteId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Elimina la flecha de retroceso
        title: const Text('Detalles del Trabajador'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => _goToDriverProfilePage(context, widget.workerImage, widget.workerName, widget.clienteId, widget.trabajadorId),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey,
                    backgroundImage: widget.workerImage.isNotEmpty                
                      ? NetworkImage(widget.workerImage) // URL de la imagen
                      : null, // Fondo gris si no hay imagen
                    child: widget.workerImage.isEmpty
                      ? const Icon(Icons.person, color: Colors.white)
                      : null,
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.workerName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.serviceType,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Campo "Número de Teléfono"
            Row(
              children: [
                const Icon(Icons.phone, color: Colors.blue, size: 20),
                const SizedBox(width: 8),
                Text(
                  widget.phoneNumber,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Campo "Correo Electrónico"
            Row(
              children: [
                const Icon(Icons.email, color: Colors.blue, size: 20),
                const SizedBox(width: 8),
                Text(
                  widget.email,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24), // Más espacio antes de la descripción

            // Descripción
            Text(
              widget.description,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 32), // Más espacio después de la descripción

            // Calendario: Fecha del servicio
            const Text(
              "Fecha del servicio",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _selectedDate == null
                          ? 'Seleccionar fecha'
                          : DateFormat('dd/MM/yyyy').format(_selectedDate!),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Abrir calendario',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Reloj: Hora del servicio
            const Text(
              "Hora del servicio",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _selectedTime == null
                          ? 'Seleccionar hora'
                          : _selectedTime!.format(context),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _selectTime(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Abrir reloj',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const Spacer(),

            // Botón "Solicitar Servicio"
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Fondo azul
                  foregroundColor: Colors.white, // Letras blancas
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  if (_selectedDate == null || _selectedTime == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Por favor selecciona una fecha y una hora.')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Servicio solicitado para: ${DateFormat('dd/MM/yyyy').format(_selectedDate!)} a las ${_selectedTime!.format(context)}',
                        ),
                      ),
                    );
                    Future.delayed(const Duration(seconds: 2), () {
                      Navigator.pop(context); // Regresa a la vista anterior (ClientHomePage)
                    });
                  }
                },
                child: const Text('Solicitar Servicio'),
              ),
            ),
            const SizedBox(height: 10), // Separación entre botones
            // Botón "Cerrar" con la "X" azul
            Center(
              child: IconButton(
                icon: const Icon(
                  Icons.close, // Ícono de "X"
                  color: Colors.blue, // Color azul
                  size: 30, // Tamaño del ícono
                ),
                onPressed: () {
                  Navigator.pop(context); // Cierra la vista
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/

import 'package:FIXITNOW/views/perfiltrabajadorclient.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart'; // Para formatear fechas y horas

class WorkerDetailsPage extends StatefulWidget {
  final String workerImage;
  final String workerName;
  final String serviceType;
  final String description;
  final String phoneNumber;
  final String email;

  const WorkerDetailsPage({
    super.key,
    required this.workerImage,
    required this.workerName,
    required this.serviceType,
    required this.description,
    required this.phoneNumber,
    required this.email,
  });

  @override
  State<WorkerDetailsPage> createState() => _WorkerDetailsPageState();
}

class _WorkerDetailsPageState extends State<WorkerDetailsPage> {
  DateTime? _selectedDate; // Fecha seleccionada
  TimeOfDay? _selectedTime; // Hora seleccionada

  // Método para seleccionar la fecha
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(), // No permite fechas pasadas
      lastDate: DateTime.now().add(const Duration(days: 365)), // Permite hasta un año
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Método para seleccionar la hora
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  // Navegar a la vista de ReviewsPage
  void _goToDriverProfilePage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const DriverProfilePage(), // Aquí redirige a ReviewsPage
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Elimina la flecha de retroceso
        title: const Text('Detalles del Trabajador'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => _goToDriverProfilePage(context), // Redirige al tocar la imagen
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey,
                    backgroundImage: widget.workerImage.isNotEmpty
                        ? NetworkImage(widget.workerImage) // URL de la imagen
                        : null, // Fondo gris si no hay imagen
                    child: widget.workerImage.isEmpty
                        ? const Icon(Icons.person, color: Colors.white)
                        : null,
                  ),
                ),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: () => _goToDriverProfilePage(context), // Redirige al tocar el nombre
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.workerName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.serviceType,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Campo "Número de Teléfono"
            Row(
              children: [
                const Icon(Icons.phone, color: Colors.blue, size: 20),
                const SizedBox(width: 8),
                Text(
                  widget.phoneNumber,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Campo "Correo Electrónico"
            Row(
              children: [
                const Icon(Icons.email, color: Colors.blue, size: 20),
                const SizedBox(width: 8),
                Text(
                  widget.email,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24), // Más espacio antes de la descripción

            // Descripción
            Text(
              widget.description,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 32), // Más espacio después de la descripción

            // Calendario: Fecha del servicio
            const Text(
              "Fecha del servicio",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _selectedDate == null
                          ? 'Seleccionar fecha'
                          : DateFormat('dd/MM/yyyy').format(_selectedDate!),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Abrir calendario',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Reloj: Hora del servicio
            const Text(
              "Hora del servicio",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _selectedTime == null
                          ? 'Seleccionar hora'
                          : _selectedTime!.format(context),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _selectTime(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Abrir reloj',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const Spacer(),

            // Botón "Solicitar Servicio"
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Fondo azul
                  foregroundColor: Colors.white, // Letras blancas
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  if (_selectedDate == null || _selectedTime == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Por favor selecciona una fecha y una hora.')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Servicio solicitado para: ${DateFormat('dd/MM/yyyy').format(_selectedDate!)} a las ${_selectedTime!.format(context)}',
                        ),
                      ),
                    );
                    Future.delayed(const Duration(seconds: 2), () {
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context); // Regresa a la vista anterior (ClientHomePage)
                    });
                  }
                },
                child: const Text('Solicitar Servicio'),
              ),
            ),
            const SizedBox(height: 10), // Separación entre botones
            // Botón "Cerrar" con la "X" azul
            Center(
              child: IconButton(
                icon: const Icon(
                  Icons.close, // Ícono de "X"
                  color: Colors.blue, // Color azul
                  size: 30, // Tamaño del ícono
                ),
                onPressed: () {
                  Navigator.pop(context); // Cierra la vista
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
