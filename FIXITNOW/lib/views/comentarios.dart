//import 'package:FIXITNOW/views/perfiltrabajadorclient.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; 
import 'dart:convert';

class ReviewsPage extends StatelessWidget {
  final String trabajadorId;

  ReviewsPage({Key? key, required this.trabajadorId}) : super(key: key);

  //funcion para obtener los comentarios desde la api
  Future<List<Review>> fetchReviews(int trabajadorId) async {
    final url = Uri.parse('http://192.168.0.24/apis/comentarios.php?trabajador_id=$trabajadorId');
    final response = await http.get(url);

    if(response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((review) => Review.fromJson(review)).toList();
    } else {
      throw Exception('Error al cargar las calificaciones');
    }
  }

  @override
  Widget build(BuildContext context) {
    final int? trabajadorIdInt = int.tryParse(trabajadorId); //convertir de string a entero

    if(trabajadorIdInt == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('El ID del trabajador no es válido.'),
        ),
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color.fromARGB(250, 70, 160, 239),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Calificaciones y Opiniones",
          style: TextStyle(
            color: Color.fromARGB(250, 70, 160, 239),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: FutureBuilder<List<Review>>(
        future: fetchReviews(trabajadorIdInt),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay calificaciones disponibles.'));
          } else {
            final reviews = snapshot.data!;
            return ListView.builder(
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final review = reviews[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Card(
                    color: const Color.fromARGB(255, 208, 230, 253),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Nombre y apellido
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: review.foto.isEmpty ? const Color.fromARGB(250, 70, 160, 239) : null,
                                backgroundImage: review.foto.isNotEmpty
                                  ? NetworkImage(review.foto)
                                  : null,
                                child: review.foto.isEmpty
                                  ? const Icon(Icons.person, color: Colors.white)//icono por defecto
                                  : null,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  '${review.name} ${review.lastName}',
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 5, 5, 5),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Calificación (estrellas)
                          Row(
                            children: List.generate(5, (starIndex) {
                              return Icon(
                                starIndex < review.rating
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Colors.amber,
                                size: 20,
                              );
                            }),
                          ),
                          const SizedBox(height: 8),
                          // Comentario
                          Text(
                            review.comment,
                            style: const TextStyle(
                              color: Color.fromARGB(255, 40, 40, 40),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
// Modelo para Review
class Review {
  final String foto;
  final String name;
  final String lastName;
  final int rating;
  final String comment;

  Review({
    required this.foto,
    required this.name,
    required this.lastName,
    required this.rating,
    required this.comment,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      foto: json['foto'] ?? '',
      name: json['nombres'] ?? '',
      lastName: json['apellidos'] ?? '',
      rating: json['puntuacion'] ?? 0,
      comment: json['comentario'] ?? '',
    );
  }
}

