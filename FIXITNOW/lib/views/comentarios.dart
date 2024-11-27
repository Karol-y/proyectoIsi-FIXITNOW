import 'package:flutter/material.dart';

class Review {
  final String name;
  final int rating; // Calificación de 1 a 5
  final String comment;

  Review({
    required this.name,
    required this.rating,
    required this.comment,
  });
}

class ReviewsPage extends StatelessWidget {
  const ReviewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Ejemplo de datos que podrían venir de una base de datos o API
    final List<Review> reviews = [
      Review(
        name: "Yeins Manjarrez Martínez",
        rating: 5,
        comment:
            "Hasta el momento no he tenido inconvenientes con las compras que he realizado. Todo me ha llegado tal cual lo pedí. Los tiempos son un poco demorados pero hay que tener en cuenta que son compras internacionales y por lo tanto la logística del envío es más exhaustiva. De manera que las compras que realicemos hay que hacerlas con tiempo. Por lo demás, ha sido excelente la experiencia en las compras realizadas sobre todo por la gran variedad de productos que ofrecen.",
      ),
      Review(
        name: "Nehyr Dagil Caviedes",
        rating: 2,
        comment:
            "He tenido inconvenientes con algunos artículos, una estación de carga, realicé el proceso de devolución y es muy desproporcionada la opción que el cliente deba correr con los gastos de envío, aspecto que desanima en devolverlos y mejor conservarlos, por cuanto al sopesar el precio del objeto con del envío, a como está el dólar, resulta costoso. Otro aspecto son los supuestos descuentos, hice la suma de los precios de estos, pero el total de la calculadora es uno y el de la App otro.",
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color.fromARGB(250, 70, 160, 239), // Color azul
          ),
          onPressed: () {
            Navigator.pop(context); // Navegar a la vista anterior
          },
        ),
        title: const Text(
          "Calificaciones y Opiniones",
          style: TextStyle(
            color: Color.fromARGB(250, 70, 160, 239), // Color azul
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: ListView.builder(
        itemCount: reviews.length,
        itemBuilder: (context, index) {
          final review = reviews[index];

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Card(
              color: const Color.fromARGB(255, 208, 230, 253), // Fondo del card
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nombre del usuario
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(
                              'https://via.placeholder.com/40'), // Placeholder de imagen
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            review.name,
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
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: ReviewsPage(),
    debugShowCheckedModeBanner: false,
  ));
}
