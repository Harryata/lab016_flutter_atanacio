import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/libro.dart';
import '../utils/constantes.dart';

class ApiGoogle {
  /// Buscar libros en Google Books API
  static Future<List<Libro>> buscarLibros(String query) async {
    final url = '${Constantes.apiGoogle}?q=$query';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final items = data['items'] as List<dynamic>? ?? [];
      return items.map((item) {
        final info = item['volumeInfo'];
        return Libro(
          id: null,
          titulo: info['title'] ?? 'Sin título',
          autor:
              (info['authors'] as List<dynamic>?)?.join(', ') ?? 'Desconocido',
          fecha: info['publishedDate'] ?? '',
          isbn:
              (info['industryIdentifiers'] != null &&
                  info['industryIdentifiers'].isNotEmpty)
              ? info['industryIdentifiers'][0]['identifier']
              : '',
          imagen: info['imageLinks'] != null
              ? info['imageLinks']['thumbnail']
              : null,
        );
      }).toList();
    } else {
      throw Exception('Error al consultar Google Books');
    }
  }
}
