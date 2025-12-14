import 'package:flutter/material.dart';
import '../models/libro.dart';
import '../theme/app_theme.dart';

class GoogleDetScreen extends StatelessWidget {
  final Libro libro;

  const GoogleDetScreen({super.key, required this.libro});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(libro.titulo),
        backgroundColor: AppTheme.navidadTheme.primaryColor,
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFF3E0), Color(0xFFFFE0B2)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Portada del libro
              if (libro.imagen != null)
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        libro.imagen!,
                        height: 250,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )
              else
                const Center(
                  child: Icon(Icons.book, size: 100, color: Colors.green),
                ),
              const SizedBox(height: 20),

              // Título
              Text(
                libro.titulo,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFB71C1C), // rojo navideño
                ),
              ),
              const SizedBox(height: 10),

              // Autor
              Text(
                'Autor: ${libro.autor}',
                style: const TextStyle(fontSize: 18, color: Colors.black87),
              ),
              const SizedBox(height: 5),

              // Fecha de publicación
              Text(
                'Publicado: ${libro.fecha}',
                style: const TextStyle(fontSize: 18, color: Colors.black87),
              ),
              const SizedBox(height: 5),

              // ISBN
              Text(
                'ISBN: ${libro.isbn}',
                style: const TextStyle(fontSize: 18, color: Colors.black87),
              ),
              const SizedBox(height: 20),

              // Botón volver
              Center(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Volver'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.navidadTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 24,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
