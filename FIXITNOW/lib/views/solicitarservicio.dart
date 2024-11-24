/*import 'package:flutter/material.dart';

import 'package:table_calendar/table_calendar.dart';

class WorkerDetailDialog extends StatefulWidget {
  const WorkerDetailDialog({super.key});

  @override
  State<WorkerDetailDialog> createState() => _WorkerDetailDialogState();
}

class _WorkerDetailDialogState extends State<WorkerDetailDialog> {
  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Encabezado con la foto y el nombre
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[200],
                    child: const Icon(Icons.person, color: Colors.white, size: 40),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nombre del trabajador',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Tipo de servicio',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blueAccent,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Aquí va la descripción del trabajador. Puede incluir experiencia, habilidades o cualquier otro detalle relevante.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  decoration: TextDecoration.none,
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 20),
              // Título "Fecha del servicio"
              const Text(
                'Fecha del servicio',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  decoration: TextDecoration.none,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TableCalendar(
                      firstDay: DateTime.now(),
                      lastDay: DateTime.now().add(const Duration(days: 365)),
                      focusedDay: focusedDay,
                      selectedDayPredicate: (day) => isSameDay(selectedDay, day),
                      onDaySelected: (selectedDayNew, focusedDayNew) {
                        setState(() {
                          selectedDay = selectedDayNew;
                          focusedDay = focusedDayNew;
                        });
                      },
                      calendarStyle: const CalendarStyle(
                        todayDecoration: BoxDecoration(
                          color: Colors.blueAccent,
                          shape: BoxShape.circle,
                        ),
                        selectedDecoration: BoxDecoration(
                          color: Colors.greenAccent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (selectedDay != null) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Fecha seleccionada: ${selectedDay!.toLocal().toString().split(' ')[0]}'),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Por favor selecciona una fecha.'),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Solicitar Servicio',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const Spacer(),
              Center(
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.blueAccent),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}*/

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Para formatear fechas y horas

class WorkerDetailsPage extends StatefulWidget {
  final String workerName;
  final String serviceType;
  final String description;
  final String phoneNumber;
  final String email;

  const WorkerDetailsPage({
    super.key,
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
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, color: Colors.white),
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


