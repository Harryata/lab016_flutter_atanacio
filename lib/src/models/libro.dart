class Libro {
  final int? id;
  final String titulo;
  final String autor;
  final String fecha;
  final String isbn;
  final String? imagen; // URL de la portada (opcional)

  Libro({
    this.id,
    required this.titulo,
    required this.autor,
    required this.fecha,
    required this.isbn,
    this.imagen,
  });

  // Convertir JSON → Libro
  factory Libro.fromJson(Map<String, dynamic> json) {
    return Libro(
      id: json['id'],
      titulo: json['titulo'],
      autor: json['autor'],
      fecha: json['fecha_publicacion'],
      isbn: json['isbn'],
      imagen: json['imagen'], // opcional para API local si no hay
    );
  }

  // Convertir Libro → JSON
  Map<String, dynamic> toJson() {
    return {
      'titulo': titulo,
      'autor': autor,
      'fecha_publicacion': fecha,
      'isbn': isbn,
      'imagen': imagen,
    };
  }
}
