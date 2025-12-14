import 'package:flutter/material.dart';
import '../api/api_google.dart';
import '../models/libro.dart';
import 'google_det.dart';
import '../theme/app_theme.dart';

class GoogleListScreen extends StatefulWidget {
  const GoogleListScreen({super.key});

  @override
  State<GoogleListScreen> createState() => _GoogleListScreenState();
}

class _GoogleListScreenState extends State<GoogleListScreen> {
  final TextEditingController _controller = TextEditingController();
  Future<List<Libro>>? _futureLibros;

  void _buscar() {
    if (_controller.text.trim().isEmpty) return;
    setState(() {
      _futureLibros = ApiGoogle.buscarLibros(_controller.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar libros (Google)'),
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
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: 'Buscar por título o autor',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(Icons.search),
                    ),
                    onSubmitted: (_) => _buscar(),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _buscar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 20,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Buscar'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _futureLibros == null
                  ? const Center(
                      child: Text(
                        'Escribe algo y presiona buscar',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
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
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 4,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 4,
                              child: ListTile(
                                leading: libro.imagen != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          libro.imagen!,
                                          width: 50,
                                          height: 70,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : const Icon(Icons.book, size: 50),
                                title: Text(
                                  libro.titulo,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(libro.autor),
                                trailing: const Icon(Icons.arrow_forward),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          GoogleDetScreen(libro: libro),
                                    ),
                                  );
                                },
                              ),
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
