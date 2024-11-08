import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class ControladorAPI {
  
  final String baseUrl = 'http://192.168.0.24/apis/api.php'; // Cambia la URL según sea necesario
  var logger = Logger();

  //método para crear un usuario
  Future<void> crearUsuario(Map<String, dynamic> usuarioData) async {
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/usuarios'));

    //verificar si hay datos
    if(usuarioData.isNotEmpty) {
      request.fields['usuario'] = usuarioData['usuario'];
      request.fields['contrasena'] = usuarioData['contrasena'];
      request.fields['tipo'] = usuarioData['tipo']; //identifica el tipo de usuario si cliente o trabajador
    } 

    //enviar la solicitud
    var response = await request.send();

    if(response.statusCode == 200) {
      logger.i('Usuario creado exitosamente');
    } else {
      throw Exception('Error al crear Usuario: ${response.statusCode}');
    }
  }

  // Método para crear un cliente
  Future<void> crearCliente(Map<String, dynamic> clienteData, String? imagePath) async {
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/clientes'));

    // Agregar los campos del cliente
    request.fields['nombres'] = clienteData['nombres'];
    request.fields['apellidos'] = clienteData['apellidos'];
    request.fields['numDoc'] = clienteData['numDoc'];
    request.fields['email'] = clienteData['email'];
    request.fields['telefono'] = clienteData['telefono'];
    request.fields['edad'] = clienteData['edad'];

    // Agregar la imagen al request si está disponible
    if (imagePath != null && imagePath.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath('foto', imagePath));
    }

    // Enviar la solicitud
    var response = await request.send();

    if (response.statusCode == 200) {
      logger.i('Cliente creado exitosamente');
    } else {
      throw Exception('Error al crear Cliente: ${response.statusCode}');
    }
  }

  // Método para crear un trabajador
  Future<void> crearTrabajador(Map<String, dynamic> trabajadorData, String? imagePath, String? certificadoPath,
    String? antecedentesPath) async {
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/trabajadores'));

    // Agregar los campos del trabajador
    request.fields['nombres'] = trabajadorData['nombres'];
    request.fields['apellidos'] = trabajadorData['apellidos'];
    request.fields['numDoc'] = trabajadorData['numDoc'];
    request.fields['email'] = trabajadorData['email'];
    request.fields['telefono'] = trabajadorData['telefono'];
    request.fields['edad'] = trabajadorData['edad'];
    request.fields['tipSer'] = trabajadorData['tipSer'];

    // Agregar la imagen al request si está disponible
    if (imagePath != null && imagePath.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath('foto', imagePath));
    }

    // Agregar el certificado al request si está disponible 
    if (certificadoPath != null && certificadoPath.isNotEmpty) { 
      request.files.add(await http.MultipartFile.fromPath('certificado', certificadoPath)); 
    } 

    // Agregar los antecedentes al request si está disponible 
    if (antecedentesPath != null && antecedentesPath.isNotEmpty) { 
      request.files.add(await http.MultipartFile.fromPath('antecedentes', antecedentesPath)); 
    }

    // Enviar la solicitud
    var response = await request.send();

    //manejo de respuestas
    var responseBody = await http.Response.fromStream(response);
    if (response.statusCode == 200 || response.statusCode == 201) {
      logger.i('Trabajador creado exitosamente');
    } else {
      logger.e('Error al crear Trabajador: ${responseBody.body}');
      throw Exception('Error al crear Trabajador: ${responseBody.body}');
    }
  }

  // Método para buscar servicios
  Future<List<dynamic>> buscarServicios(String nombreServicio) async {
    final response = await http.get(
      Uri.parse('$baseUrl/servicios?nombreServicio=$nombreServicio'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      logger.e('Error al buscar Servicios: ${response.statusCode}');
      throw Exception('Error al buscar servicios: ${response.body}');
    }
  }

  // Método para crear un servicio
  Future<void> crearServicio(Map<String, dynamic> servicioData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/servicios'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(servicioData),
    );

    if (response.statusCode == 201) {
      logger.i('Servicio creado: ${response.body}');
    } else {
      logger.e('Error al crear Servicio: ${response.body}');
      throw Exception('Error al crear servicio: ${response.body}');
    }
  }

  // Método para subir documentos
  Future<void> subirDocumentos(String certificadoPath, String antecedentesPath) async {
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/uploadDocuments'));

    // Agregar los archivos al request
    request.files.add(await http.MultipartFile.fromPath('certificado', certificadoPath));
    request.files.add(await http.MultipartFile.fromPath('antecedentes', antecedentesPath));

    // Enviar la solicitud
    var response = await request.send();

    if (response.statusCode == 200) {
      logger.i('Documentos subidos exitosamente');
    } else {
      logger.e('Error al subir documentos: ${response.statusCode}');
      throw Exception('Error al subir documentos: ${response.statusCode}');
    }
  }
}