import 'package:flutter/material.dart';
import '../api/api_local.dart';
import '../models/libro.dart';

class LocalFormScreen extends StatefulWidget {
  final Libro? libro;

  const LocalFormScreen({super.key, this.libro});

  @override
  State<LocalFormScreen> createState() => _LocalFormScreenState();
}

class _LocalFormScreenState extends State<LocalFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _tituloCtrl = TextEditingController();
  final _autorCtrl = TextEditingController();
  final _fechaCtrl = TextEditingController();
  final _isbnCtrl = TextEditingController();

  bool _guardando = false;

  bool get esEditar => widget.libro != null;

  @override
  void initState() {
    super.initState();

    if (esEditar) {
      _tituloCtrl.text = widget.libro!.titulo;
      _autorCtrl.text = widget.libro!.autor;
      _fechaCtrl.text = widget.libro!.fecha;
      _isbnCtrl.text = widget.libro!.isbn;
    }
  }

  @override
  void dispose() {
    _tituloCtrl.dispose();
    _autorCtrl.dispose();
    _fechaCtrl.dispose();
    _isbnCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _guardando = true);

    final libro = Libro(
      id: widget.libro?.id ?? 0,
      titulo: _tituloCtrl.text,
      autor: _autorCtrl.text,
      fecha: _fechaCtrl.text,
      isbn: _isbnCtrl.text,
    );

    try {
      if (esEditar) {
        await ApiLocal.actualizarLibro(libro);
      } else {
        await ApiLocal.crearLibro(libro);
      }

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            esEditar ? 'Error al actualizar libro' : 'Error al crear libro',
          ),
        ),
      );
    } finally {
      setState(() => _guardando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(esEditar ? 'Editar Libro' : 'Agregar Libro')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _input(_tituloCtrl, 'Título'),
              _input(_autorCtrl, 'Autor'),
              _input(_fechaCtrl, 'Año de publicación'),
              _input(_isbnCtrl, 'ISBN'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _guardando ? null : _guardar,
                child: _guardando
                    ? const CircularProgressIndicator()
                    : Text(esEditar ? 'Actualizar' : 'Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _input(TextEditingController ctrl, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: ctrl,
        decoration: InputDecoration(labelText: label),
        validator: (v) => v == null || v.isEmpty ? 'Campo obligatorio' : null,
      ),
    );
  }
}
