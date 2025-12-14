import 'package:flutter/material.dart';
import 'local_list.dart';
import 'google_list.dart';

class InicioScreen extends StatelessWidget {
  const InicioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('API Libros')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _cardOpcion(
              context,
              titulo: '📚 Mis Libros',
              subtitulo: 'API Local - CRUD completo',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LocalListScreen()),
                );
              },
            ),
            const SizedBox(height: 16),
            _cardOpcion(
              context,
              titulo: '🌍 Buscar Libros',
              subtitulo: 'Google Books API - Solo lectura',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const GoogleListScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardOpcion(
    BuildContext context, {
    required String titulo,
    required String subtitulo,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      child: ListTile(
        title: Text(
          titulo,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitulo),
        trailing: const Icon(Icons.arrow_forward),
        onTap: onTap,
      ),
    );
  }
}
