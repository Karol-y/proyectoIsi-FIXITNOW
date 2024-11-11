import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart'; //importa file_picker
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:FIXITNOW/controllers/controlador_api.dart'; // Asegúrate de que este sea el nombre correcto
import 'doctrabajador.dart'; // Importa la vista donde se subirán los documentos

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: WorkerForm(),
    );
  }
}

class WorkerForm extends StatefulWidget {
  const WorkerForm({super.key});

  @override
  _WorkerFormState createState() => _WorkerFormState();
}

class _WorkerFormState extends State<WorkerForm> {
  final _formKey = GlobalKey<FormState>();
  File? _image;
  File? _certificado; //variable para almacenar la imagen del certificado
  File? _antecedente; //variable para almacenar la imagen de antecedentes
  final ControladorAPI controlador = ControladorAPI(); // Instancia del controlador API

  // Controladores para los campos de texto
  TextEditingController nombresController = TextEditingController();
  TextEditingController apellidosController = TextEditingController();
  TextEditingController docController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController telefonoController = TextEditingController();
  TextEditingController edadController = TextEditingController();
  TextEditingController servicioController = TextEditingController();
  TextEditingController usuarioController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  String tipoUsuario = 'trabajador'; //fija el tipo de usuario

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickCertificado() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if(result != null && result.files.isNotEmpty) {
      setState(() {
        _certificado = File(result.files.first.path!); //acceder al primer archivo 
      });
    }  
  }

  Future<void> _pickAntecedente() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf'],);
    if(result != null && result.files.isNotEmpty) {
      setState(() {
        _antecedente = File(result.files.first.path!); //acceder al primer archivo
      });
    }
  }

  void _enviarFormulario() async {
    if (_formKey.currentState?.validate() ?? false) {
      //inserta primero los datos para el usuario
      /*Map<String, dynamic> usuarioData = {
        "usuario": usuarioController.text,
        "contrasena": passwordController.text,
        "tipo": tipoUsuario,
      };*/
      //verifica que los documentos han sido seleccionados
      if(_certificado == null || _antecedente == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Debe seleccionar el certificado y el antecedente')),
        );
      }
      // Crear un mapa con los datos del trabajador
      Map<String, dynamic> trabajadorData = {
        "nombres": nombresController.text,
        "apellidos": apellidosController.text,
        "numDoc": docController.text, // Mantener como String
        "email": emailController.text,
        "telefono": telefonoController.text, // Mantener como String
        "edad": edadController.text, // Convertir a entero
        "tipSer": servicioController.text,
        "usuario": usuarioController.text,
        "contrasena": passwordController.text,
      };

      //compara y verifica la contraseña
      if (passwordController.text != confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Las contraseñas no coinciden')),
        );
        return;
      }

      try {
        //navegar a la vista para seleccionar los documentos
        final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => const DocTrabajador()),);

        //verifica si el resultado es valido, que los documentos hayan sido seleccionados
        if(result != null) {
          String certificadoPath = result['certificado'];
          String antecedentesPath = result['antecedente'];

          //llamar al metodo del controlador con los documentos y los demas documentos
          await controlador.crearTrabajador(trabajadorData, _image?.path, certificadoPath, antecedentesPath);
          
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Trabajador registrado exitosamente')),);
          const SnackBar(content: Text('Trabajador registrado exitosamente'));        
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al crear trabajador: $e')));
      }

      /*try {
        // Llama al método del controlador y pasa la ruta de la imagen
        //await controlador.crearUsuario(usuarioData); //llama al método del controlador
        await controlador.crearTrabajador(trabajadorData, _image?.path, _certificado?.path, _antecedente?.path,); // Llama al método del controlador 
        // Navega a la siguiente vista para subir documentos
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DocTrabajador()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al crear trabajador: $e')));
      }*/
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulario de Trabajador'),
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
                    'Trabajador',
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
                    _buildTextField('Tipo de Servicio', servicioController),
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
            Navigator.pop(context); // Acción para el botón Atrás
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
          child: const Text('Atrás'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              // Llamar al método para enviar el formulario
              _enviarFormulario(); 
            }
          },
          child: const Text('Seguir'),
        ),
      ],
    );
  }
}