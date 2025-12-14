import 'package:flutter/material.dart';
import '../models/libro.dart';
import '../api/api_local.dart';
import 'local_form.dart';

/// Pantalla de detalle de un libro local
/// Muestra toda la información del libro y permite editar o eliminar
class LocalDetScreen extends StatelessWidget {
  final Libro libro;

  const LocalDetScreen({super.key, required this.libro});

  /// Función para eliminar el libro con confirmación
  Future<void> _confirmarEliminar(BuildContext context, int id) async {
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
      try {
        await ApiLocal.eliminarLibro(id);
        Navigator.pop(context, true); // Volver a la lista y refrescar
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Libro eliminado')));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al eliminar libro')),
        );
      }
    }
  }

  /// Función para navegar al formulario de edición
  Future<void> _editarLibro(BuildContext context) async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => LocalFormScreen(libro: libro)),
    );

    if (resultado == true) {
      Navigator.pop(context, true); // Volver a la lista y refrescar
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(libro.titulo),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _editarLibro(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _confirmarEliminar(context, libro.id!),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título
            Text(
              libro.titulo,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Autor
            Text('Autor: ${libro.autor}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 5),

            // Año de publicación
            Text('Año: ${libro.fecha}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 5),

            // ISBN
            Text('ISBN: ${libro.isbn}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),

            // Botón de editar (opcional, ya hay en AppBar)
            ElevatedButton.icon(
              icon: const Icon(Icons.edit),
              label: const Text('Editar'),
              onPressed: () => _editarLibro(context),
            ),
          ],
        ),
      ),
    );
  }
}
