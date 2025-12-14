import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData navidadTheme = ThemeData(
    // Colores principales
    primaryColor: const Color(0xFFC62828), // Rojo vivo
    secondaryHeaderColor: const Color(0xFF388E3C), // Verde oscuro
    // Fondo general de la app
    scaffoldBackgroundColor: const Color(0xFFFFF3E0), // Fondo crema suave
    // AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF2E7D32), // Verde
      foregroundColor: Colors.white,
      elevation: 4,
      titleTextStyle: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),

    // Botón flotante
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFFFFD600), // Dorado brillante
      foregroundColor: Colors.white,
    ),

    // Botones principales
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFD32F2F), // Rojo navideño
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),

    // Textos
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: Color(0xFFD32F2F), // Rojo para títulos
        fontWeight: FontWeight.bold,
        fontSize: 28,
      ),
      titleLarge: TextStyle(
        color: Color(0xFF388E3C), // Verde para subtítulos
        fontWeight: FontWeight.w600,
        fontSize: 20,
      ),
      bodyLarge: TextStyle(
        color: Color(0xFF6D4C41), // Marrón cálido para texto normal
        fontSize: 16,
      ),
      bodyMedium: TextStyle(
        color: Color(0xFFBF360C), // Rojo más oscuro para detalles
        fontSize: 14,
      ),
    ),

    // Colores de acento para iconos y destacados
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: const Color(0xFFFFD600), // Dorado brillante
    ),
  );
}
