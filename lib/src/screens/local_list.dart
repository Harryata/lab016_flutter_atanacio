import 'package:flutter/material.dart';
import '../api/api_local.dart';
import '../models/libro.dart';
import 'local_form.dart';
import 'local_det.dart';

/// Pantalla principal que muestra la lista de libros de la API local.
/// Permite: leer, agregar, editar, eliminar y ver detalle de cada libro.
class LocalListScreen extends StatefulWidget {
  const LocalListScreen({super.key});

  @override
  State<LocalListScreen> createState() => _LocalListScreenState();
}

class _LocalListScreenState extends State<LocalListScreen> {
  // Future que obtiene los libros desde la API
  late Future<List<Libro>> _futureLibros;

  @override
  void initState() {
    super.initState();
    _cargar(); // Cargar los libros al iniciar
  }

  /// Carga la lista de libros desde la API local
  void _cargar() {
    _futureLibros = ApiLocal.getLibros();
  }

  /// Navega a la pantalla de agregar libro
  /// y recarga la lista si se agregó correctamente
  Future<void> _irAgregar() async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LocalFormScreen()),
    );

    if (resultado == true) {
      setState(() => _cargar());
    }
  }

  /// Muestra un diálogo de confirmación antes de eliminar un libro
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

    if (confirmar == true) {
      _eliminar(id);
    }
  }

  /// Llama al método DELETE de la API y recarga la lista
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
      appBar: AppBar(title: const Text('Mis Libros (API Local)')),
      // Botón flotante para agregar libro
      floatingActionButton: FloatingActionButton(
        onPressed: _irAgregar,
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Libro>>(
        future: _futureLibros,
        builder: (context, snapshot) {
          // Mientras carga los libros, mostramos un spinner
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Si hay error en la petición
          if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar libros'));
          }

          final libros = snapshot.data!;

          // Si la lista está vacía
          if (libros.isEmpty) {
            return const Center(child: Text('No hay libros'));
          }

          // ListView con cada libro
          return ListView.builder(
            itemCount: libros.length,
            itemBuilder: (context, index) {
              final libro = libros[index];
              return ListTile(
                title: Text(libro.titulo),
                subtitle: Text(libro.autor),

                /// Al tocar la fila, abrir pantalla de detalle
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LocalDetScreen(libro: libro),
                    ),
                  );
                },

                // Trailing con íconos para editar y eliminar
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Ícono de editar
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () async {
                        final resultado = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => LocalFormScreen(libro: libro),
                          ),
                        );

                        if (resultado == true) {
                          setState(() => _cargar());
                        }
                      },
                    ),
                    // Ícono de eliminar
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      // Null-safety: libro.id puede ser int?
                      onPressed: libro.id != null
                          ? () => _confirmarEliminar(libro.id!)
                          : null,
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
