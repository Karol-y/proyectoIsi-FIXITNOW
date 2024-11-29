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

    if (response.statusCode == 201) {
      var responseBody = await response.stream.bytesToString();
      logger.i('Cliente creado exitosamente $responseBody');
    } else {
      var responseBody = await response.stream.bytesToString();
      logger.e('Error al crear Cliente: ${response.statusCode}, Detalle: $responseBody');
      throw Exception('Error al crear Cliente: ${response.statusCode}');
    }
  }

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


    // Enviar la solicitud para crear al trabajador
    var response = await request.send();

    //si los documentos no son nulos, subirlos
    if (response.statusCode == 201) {
      var responseBody = await response.stream.bytesToString();
      logger.i('Trabajador creado exitosamente: $responseBody');

    } else {
      var responseBody = await response.stream.bytesToString();
      logger.e('Error al crear Trabajador: ${response.statusCode}, Detalle: $responseBody');
      throw Exception('Error al crear Trabajador: ${response.statusCode}');
    }
  }

  //Método para crear un servicio
  Future<void> enviarCalificacionOpinion({
    required String trabajadorId,
    required String clienteId,
    required int rating,
    required String opinion,
    }) async {
      //url de la api para enviar la calificacion
      const String apiUrl = 'http://192.168.0.24/apis/api.php';

      //Datos que se enviarán a la solicitud
      final Map<String, dynamic> calificacionData = {
        'trabajador_id': trabajadorId.toString(),
        'cliente_id': clienteId,
        'puntuacion': rating.toString(),
        'comentario': opinion,
      };

      try {
        //realizar la solicitud post
        final response = await http.post(
          Uri.parse('$apiUrl/calificaciones'),
          headers: {
            'Content-type': 'application/json',
          },
          body: jsonEncode(calificacionData),
        );

        //verificar la respuesta del servidor
        if(response.statusCode == 201) {
          print('Calificación enviada con éxito');
        } else {
          print('Error al enviar la calificación: ${response.body}');
        }
      }catch(e) {
        print('Error en al solicitud: $e');
      }
  }
}