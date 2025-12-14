import 'package:flutter/material.dart';
import '../models/libro.dart';

/// Pantalla de detalle de un libro de Google Books
/// Muestra portada, título, autor, fecha y ISBN
class GoogleDetScreen extends StatelessWidget {
  final Libro libro;

  const GoogleDetScreen({super.key, required this.libro});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(libro.titulo)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Portada del libro
            if (libro.imagen != null)
              Center(
                child: Image.network(
                  libro.imagen!,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              )
            else
              const Center(child: Icon(Icons.book, size: 100)),
            const SizedBox(height: 20),

            // Título
            Text(
              libro.titulo,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Autor
            Text('Autor: ${libro.autor}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 5),

            // Fecha de publicación
            Text(
              'Publicado: ${libro.fecha}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 5),

            // ISBN
            Text('ISBN: ${libro.isbn}', style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
