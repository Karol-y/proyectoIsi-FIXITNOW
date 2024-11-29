import 'package:flutter/material.dart';

class ClientProfilePage extends StatelessWidget {
  final String clientImage;
  final String clientName;
  final String phoneNumber;
  final String email;

  const ClientProfilePage({
    super.key,
    required this.clientImage,
    required this.clientName,
    required this.phoneNumber,
    required this.email,
  });

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
          "Perfil del Cliente",
          style: TextStyle(
            color: Color.fromARGB(250, 70, 160, 239),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 254, 254),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey,
                backgroundImage: clientImage.isNotEmpty
                    ? NetworkImage(clientImage)
                    : null,
                child: clientImage.isEmpty
                    ? const Icon(Icons.person, color: Colors.white, size: 50)
                    : null,
              ),
              const SizedBox(height: 16),
              Text(
                clientName.isNotEmpty ? clientName : "Nombre no disponible",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.phone, color: Colors.blue),
                  const SizedBox(width: 8),
                  Text(
                    phoneNumber.isNotEmpty ? phoneNumber : "Teléfono no disponible",
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.email, color: Colors.blue),
                  const SizedBox(width: 8),
                  Text(
                    email.isNotEmpty ? email : "Correo no disponible",
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
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
    home: ClientProfilePage(
      clientImage: '',
      clientName: 'Nombre del Cliente',
      phoneNumber: '123456789',
      email: 'correo@ejemplo.com',
    ),
  ));
}
