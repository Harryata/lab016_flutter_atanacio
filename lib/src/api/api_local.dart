import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/libro.dart';
import '../utils/constantes.dart';

class ApiLocal {
  // GET: obtener lista de libros
  static Future<List<Libro>> getLibros() async {
    final url = Uri.parse(Constantes.apiLocal);

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => Libro.fromJson(e)).toList();
    } else {
      throw Exception('Error al cargar libros');
    }
  }

  // POST: crear libro
  static Future<void> crearLibro(Libro libro) async {
    final url = Uri.parse(Constantes.apiLocal);

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(libro.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Error al crear libro');
    }
  }

  // PUT: actualizar libro
  static Future<void> actualizarLibro(Libro libro) async {
    final url = Uri.parse('${Constantes.apiLocal}${libro.id}/');

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(libro.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar libro');
    }
  }

  // DELETE: eliminar libro
  static Future<void> eliminarLibro(int id) async {
    final url = Uri.parse('${Constantes.apiLocal}$id/');

    final response = await http.delete(url);

    if (response.statusCode != 204) {
      throw Exception('Error al eliminar libro');
    }
  }
}
