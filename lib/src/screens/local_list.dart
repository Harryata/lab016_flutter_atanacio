import 'package:flutter/material.dart';
import '../api/api_local.dart';
import '../models/libro.dart';
import 'local_form.dart';
import 'local_det.dart';
import '../theme/app_theme.dart';

class LocalListScreen extends StatefulWidget {
  const LocalListScreen({super.key});

  @override
  State<LocalListScreen> createState() => _LocalListScreenState();
}

class _LocalListScreenState extends State<LocalListScreen> {
  late Future<List<Libro>> _futureLibros;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  void _cargar() {
    _futureLibros = ApiLocal.getLibros();
  }

  Future<void> _irAgregar() async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LocalFormScreen()),
    );

    if (resultado == true) setState(() => _cargar());
  }

  Future<void> _confirmarEliminar(int id) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar libro'),
        content: const Text('¿Estás seguro de eliminar este libro?'),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.pop(context, false),
          ),
          ElevatedButton(
            child: const Text('Eliminar'),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirmar == true) _eliminar(id);
  }

  Future<void> _eliminar(int id) async {
    try {
      await ApiLocal.eliminarLibro(id);
      setState(() => _cargar());
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Libro eliminado')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Error al eliminar libro')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📚 Mis Libros Navideños'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _irAgregar,
        child: const Icon(Icons.add),
        backgroundColor: AppTheme.navidadTheme.primaryColor,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFF3E0), Color(0xFFFFE0B2)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder<List<Libro>>(
          future: _futureLibros,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text('Error al cargar libros'));
            }
            final libros = snapshot.data!;
            if (libros.isEmpty) {
              return const Center(child: Text('No hay libros'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: libros.length,
              itemBuilder: (context, index) {
                final libro = libros[index];
                return Card(
                  color: Colors.white.withOpacity(0.9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 6,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      libro.titulo,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text(libro.autor),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LocalDetScreen(libro: libro),
                        ),
                      );
                    },
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.green),
                          onPressed: () async {
                            final resultado = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => LocalFormScreen(libro: libro),
                              ),
                            );
                            if (resultado == true) setState(() => _cargar());
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: libro.id != null
                              ? () => _confirmarEliminar(libro.id!)
                              : null,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
