import 'package:flutter/material.dart';
import '../api/api_google.dart';
import '../models/libro.dart';
import 'google_det.dart';

class GoogleListScreen extends StatefulWidget {
  const GoogleListScreen({super.key});

  @override
  State<GoogleListScreen> createState() => _GoogleListScreenState();
}

class _GoogleListScreenState extends State<GoogleListScreen> {
  final TextEditingController _controller = TextEditingController();
  Future<List<Libro>>? _futureLibros;

  void _buscar() {
    setState(() {
      _futureLibros = ApiGoogle.buscarLibros(_controller.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buscar libros (Google)')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Buscar por título o autor',
                    ),
                  ),
                ),
                IconButton(icon: const Icon(Icons.search), onPressed: _buscar),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _futureLibros == null
                  ? const Center(child: Text('Escribe algo y presiona buscar'))
                  : FutureBuilder<List<Libro>>(
                      future: _futureLibros,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.hasError) {
                          return const Center(
                            child: Text('Error al cargar libros'),
                          );
                        }
                        final libros = snapshot.data!;
                        if (libros.isEmpty) {
                          return const Center(
                            child: Text('No se encontraron libros'),
                          );
                        }
                        return ListView.builder(
                          itemCount: libros.length,
                          itemBuilder: (context, index) {
                            final libro = libros[index];
                            return ListTile(
                              leading: libro.imagen != null
                                  ? Image.network(
                                      libro.imagen!,
                                      width: 50,
                                      fit: BoxFit.cover,
                                    )
                                  : const Icon(Icons.book),
                              title: Text(libro.titulo),
                              subtitle: Text(libro.autor),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        GoogleDetScreen(libro: libro),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
