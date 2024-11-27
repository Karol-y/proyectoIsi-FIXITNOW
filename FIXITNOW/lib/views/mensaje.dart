import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:FIXITNOW/controllers/controlador_mensajes.dart';

void main() {
  runApp(ChatApp());
}

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ControladorMensaje _controladorMensaje = ControladorMensaje();
  final TextEditingController _messageController = TextEditingController();
  List<Map<String, dynamic>> _chats = [];
  List<Map<String, dynamic>> _messages = [];
  late int _selectedChatId; // Marcar como 'late'

  @override
  void initState() {
    super.initState();
    _loadChats();
  }

  void _loadChats() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.0.24/apis/mensajes.php')); // URL de la API
      if (response.statusCode == 200) {
        final List<dynamic> chatData = jsonDecode(response.body);
        setState(() {
          _chats = chatData.isNotEmpty
            ? chatData.map((chat) => {
            'id': chat['id'],
            'name': chat['name'],
          }).toList()
          :[];
        });
      } else {
        throw Exception('Error al cargar chats: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al cargar chats: $e');
    }
  }

  void _loadMessages(int chatId) async {
    final messages = await _controladorMensaje.obtenerMensajes(1, chatId); // IDs de ejemplo
    setState(() {
      _selectedChatId = chatId;
      _messages = messages;
    });
  }

  void _sendMessage() async {
    final message = _messageController.text;
    if (message.isNotEmpty) {
      await _controladorMensaje.enviarMensaje(1, _selectedChatId, message); // IDs de ejemplo
      _messageController.clear();
      _loadMessages(_selectedChatId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.chat_bubble_outline,
                  color: Color.fromARGB(255, 50, 52, 53),
                ),
              ),
            ),
            const SizedBox(width: 10),
            const Text('Chat'),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _chats.isEmpty
              ? Center(
                child: Text('No tienes ningún chat',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
            : Row(
              children: [
                // Lista de chats
                Expanded(
                  flex: 1,
                  child: ListView.builder(
                    itemCount: _chats.length,
                    itemBuilder: (context, index) {
                      final chat = _chats[index];
                      return ListTile(
                        title: Text(chat['name']),
                        onTap: () {
                          _loadMessages(chat['id']);
                        },
                      );
                    },
                  ),
                ),
                // Conversación seleccionada
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: _messages.length,
                          itemBuilder: (context, index) {
                            final msg = _messages[index];
                            return Row(
                              mainAxisAlignment: msg['sender_id'] == 1
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: msg['sender_id'] == 1
                                        ? Colors.cyanAccent
                                        : Colors.grey[300],
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.black),
                                  ),
                                  child: Text(
                                    msg['message'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      // Barra de escritura de mensajes
                      Container( 
                        padding: const EdgeInsets.symmetric(horizontal: 8.0), 
                        color: Colors.white, 
                        child: Row( 
                          children: [ 
                            Expanded( 
                              child: TextField( 
                                controller: _messageController, 
                                decoration: InputDecoration( 
                                  hintText: 'Escribir', 
                                  border: OutlineInputBorder( 
                                    borderRadius: BorderRadius.circular(10), 
                                  ), 
                                ), 
                                onSubmitted: (text) { 
                                  _sendMessage(); 
                                }, 
                              ),
                            ), 
                            IconButton( 
                              icon: const Icon(Icons.send, color: Colors.lightBlueAccent), 
                              onPressed: _sendMessage, 
                            ), 
                          ], 
                        ), 
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
