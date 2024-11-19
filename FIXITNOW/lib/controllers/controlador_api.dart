import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class ControladorAPI {
  
  final String baseUrl = 'http://192.168.0.24/apis/api.php'; // Cambia la URL según sea necesario
  var logger = Logger();

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
    request.fields['usuario'] = clienteData['usuario'];
    request.fields['contrasena'] = clienteData['contrasena'];

    // Agregar la imagen al request si está disponible
    if (imagePath != null && imagePath.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath('foto', imagePath));
    }

    // Enviar la solicitud
    var response = await request.send();

    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();
      logger.i('Cliente creado exitosamente $responseBody');
    } else {
      var responseBody = await response.stream.bytesToString();
      logger.e('Error al crear Cliente: ${response.statusCode}, Detalle: $responseBody');
      throw Exception('Error al crear Cliente: ${response.statusCode}');
    }
  }

  // Método para subir documentos
  /*Future<void> subirDocumentos(String certificadoPath, String antecedentesPath) async {
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/uploadDocuments'));

    // Agregar los archivos al request
    if(certificadoPath.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath('certificado', certificadoPath));
    } else {
      throw Exception('La ruta del certificado es inválida');
    }
    
    if(certificadoPath.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath('antecedentes', antecedentesPath));
    } else {
      throw Exception('La ruta del antecedente es inválida');
    }
    
    // Enviar la solicitud
    var response = await request.send();

    if (response.statusCode == 200) {
      logger.i('Documentos subidos exitosamente');
    } else {
      throw Exception('Error al subir documentos: ${response.statusCode}');
    }
  }*/

  Future<Map <String, String>> subirDocumentos(String certificadoPath, String antecedentesPath) async {
   
    if(certificadoPath.isEmpty || antecedentesPath.isEmpty) {
      throw Exception('Las rutas de los documentos son inválidas');
    }

    final Map<String, String> documentosValidos = {};

    if(certificadoPath.isNotEmpty) {
      documentosValidos['certificado'] = certificadoPath;
    } else {
      throw Exception('La ruta del certificado es inválida');
    }

    if(antecedentesPath.isNotEmpty) {
      documentosValidos['antecedente'] = antecedentesPath;
    } else {
      throw Exception('La ruta de antecedentes es inválida');
    }

    return documentosValidos;
  }

  // Método para crear un trabajador
  Future<void> crearTrabajador(Map<String, dynamic> trabajadorData, String? imagePath, String? certificadoPath, String? antecedentesPath) async {
    
    if(certificadoPath == null || antecedentesPath == null) {
      throw Exception('Las rutas de los documentos no pueden ser nulas');
    }

    final Map<String, String> documentos = await subirDocumentos(certificadoPath, antecedentesPath);
    
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/trabajadores'));

    // Agregar los campos del trabajador
    request.fields['nombres'] = trabajadorData['nombres'];
    request.fields['apellidos'] = trabajadorData['apellidos'];
    request.fields['numDoc'] = trabajadorData['numDoc'];
    request.fields['email'] = trabajadorData['email'];
    request.fields['telefono'] = trabajadorData['telefono'];
    request.fields['edad'] = trabajadorData['edad'];
    request.fields['tipSer'] = trabajadorData['tipSer'];
    request.fields['usuario'] = trabajadorData['usuario'];
    request.fields['contrasena'] = trabajadorData['contrasena'];

    // Agregar la imagen al request si está disponible
    if (imagePath != null && imagePath.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath('foto', imagePath));
    }

    if(documentos['certificado']?.isNotEmpty ?? false) {
      request.files.add(await http.MultipartFile.fromPath('certificado', documentos['certificado'] ?? ''));
    }
    
    if(documentos['antecedente']?.isNotEmpty ?? false) {
      request.files.add(await http.MultipartFile.fromPath('antecedente', documentos['antecedente'] ?? ''));
    }

    // Agregar el certificado al request si está disponible 
    /*if (certificadoPath != null && certificadoPath.isNotEmpty) { 
      request.files.add(await http.MultipartFile.fromPath('certificado', certificadoPath)); 
    } 

    // Agregar los antecedentes al request si está disponible 
    if (antecedentesPath != null && antecedentesPath.isNotEmpty) { 
      request.files.add(await http.MultipartFile.fromPath('antecedentes', antecedentesPath)); 
    }*/

    // Enviar la solicitud para crear al trabajador
    var response = await request.send();

    /*if (certificadoPath != null && antecedentesPath != null) {
      // Llamar a la función que espera un String no nulo
      subirDocumentos(certificadoPath, antecedentesPath);
    } else {
      // Manejar el caso en que certificadoPath es null
      // Mostrar un mensaje de error al usuario
      logger.e('Por favor, selecciona ambos documentos: Certificado y Antecedentes');
    }*/

    //si los documentos no son nulos, subirlos
    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();
      logger.i('Trabajador creado exitosamente: $responseBody');
      // Después de crear el trabajador, subimos los documentos
      /*if(certificadoPath != null && certificadoPath.isNotEmpty && antecedentesPath != null && antecedentesPath.isNotEmpty) {
        //subir los documentos solo si ambor estan disponibles
        await subirDocumentos(certificadoPath, antecedentesPath);
      } else {
        logger.e('Por favor, selecciona ambos documentos: Certificado y Antecedentes');
      }*/

    } else {
      var responseBody = await response.stream.bytesToString();
      logger.e('Error al crear Trabajador: ${response.statusCode}, Detalle: $responseBody');
      throw Exception('Error al crear Trabajador: ${response.statusCode}');
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

  /*Método para crear un servicio
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
  }*/
}