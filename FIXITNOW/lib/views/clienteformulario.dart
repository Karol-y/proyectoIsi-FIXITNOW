import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:FIXITNOW/controllers/controlador_api.dart'; // Asegúrate de que este sea el nombre correcto
import 'registroexito.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ClienteFormulario(),
    );
  }
}

class ClienteFormulario extends StatefulWidget {
  const ClienteFormulario({super.key});

  @override
  _ClienteFormularioState createState() => _ClienteFormularioState();
}

class _ClienteFormularioState extends State<ClienteFormulario> {
  final _formKey = GlobalKey<FormState>();
  File? _image;
  final ControladorAPI api = ControladorAPI(); // Instancia del controlador API

  // Controladores para los campos de texto
  TextEditingController nombresController = TextEditingController();
  TextEditingController apellidosController = TextEditingController();
  TextEditingController docController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController telefonoController = TextEditingController();
  TextEditingController edadController = TextEditingController();
  TextEditingController usuarioController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  
  String tipoUsuario = 'cliente'; //fija el tipo de usuario

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _enviarFormulario() async {
    if (_formKey.currentState?.validate() ?? false) {
      /*Map<String, dynamic> usuarioData = {
        "usuario": usuarioController.text,
        "contrasena": passwordController.text,
        "tipo": tipoUsuario,
      };*/
      // Crear un mapa con los datos del cliente
      Map<String, dynamic> clienteData = {
        "nombres": nombresController.text,
        "apellidos": apellidosController.text,
        "numDoc": docController.text, // Mantener como String
        "email": emailController.text,
        "telefono": telefonoController.text, // Mantener como String
        "edad": edadController.text, // Convertir a entero
        "usuario": usuarioController.text,
        "contrasena": passwordController.text,
      };

      //COMPARA Y VERIFICA LAS CONTRASEÑAS
      if (passwordController.text != confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Las contraseñas no coinciden')),
        );
        return;
      }

      try {
        //instancia del controlador y llamado de ambos métodos
        ControladorAPI controlador = ControladorAPI();
        //await controlador.crearUsuario(usuarioData); //llama al método del controlador
        await controlador.crearCliente(clienteData, _image?.path); // Llama al método del controlador 
        Registroexito.mostrarDialogoExitoso(context, '¡El registro ha sido exitoso!'); // Muestra el diálogo de éxito
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al crear cliente: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulario de Cliente'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF86C5F5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text(
                    'Cliente',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildPhotoPicker(),
                    _buildTextField('Nombres', nombresController),
                    _buildTextField('Apellidos', apellidosController),
                    _buildTextField('N° Doc Identidad', docController),
                    _buildTextField('Email', emailController, keyboardType: TextInputType.emailAddress),
                    _buildPhoneField(telefonoController),
                    _buildTextField('Edad', edadController, keyboardType: TextInputType.number),
                    _buildTextField('Usuario', usuarioController),
                    _buildTextField('Contraseña', passwordController, obscureText: true),
                    _buildTextField('Confirmar Contraseña', confirmPasswordController, obscureText: true),
                    const SizedBox(height: 20),
                    _buildButtons(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Método para crear el campo de teléfono con el prefijo "+57"
  Widget _buildPhoneField(TextEditingController controller) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.phone,
      decoration: const InputDecoration(
        prefixText: '+57 ',
        labelText: 'Teléfono',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor ingrese un número de teléfono válido';
        }
        return null;
      },
    );
  }

  Widget _buildPhotoPicker() {
    return Row(
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: CircleAvatar(
            radius: 40,
            backgroundColor: Colors.blueAccent,
            child: _image == null
                ? const Icon(Icons.camera_alt, size: 40, color: Colors.white)
                : ClipOval(
                    child: Image.file(
                      _image!,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
          ),
        ),
        const SizedBox(width: 10),
        const Text('Subir Foto'),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text, bool obscureText = false, String hint = ''}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor ingresa $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context); // Lógica para el botón Atrás
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
          child: const Text('Atrás'),
        ),
        ElevatedButton(
          onPressed: _enviarFormulario, // Llama al método para enviar el formulario
          child: const Text('Registrarse'),
        ),
      ],
    );
  }
}