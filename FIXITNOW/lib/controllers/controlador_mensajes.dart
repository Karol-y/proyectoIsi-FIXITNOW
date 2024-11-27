import 'package:http/http.dart' as http;
import 'dart:convert';

class ControladorMensaje {
  final String apiUrl = 'http://192.168.0.24/apis/mensajes.php';

  Future<void> enviarMensaje(int senderId, int receiverId, String message) async {
    final response = await http.post(
      Uri.parse('$apiUrl?action=sendMessage'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'sender_id': senderId,
        'receiver_id': receiverId,
        'message': message,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al enviar mensaje: ${response.statusCode}');
    }
  }

  Future<List<Map<String, dynamic>>> obtenerMensajes(int user1Id, int user2Id) async {
    final response = await http.get(
      Uri.parse('$apiUrl?action=getMessages&user1_id=$user1Id&user2_id=$user2Id'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> messages = jsonDecode(response.body);
      return messages.map((msg) => {
        'sender_id': msg['sender_id'],
        'message': msg['message'],
      }).toList();
    } else {
      throw Exception('Error al obtener mensajes: ${response.statusCode}');
    }
  }
}
