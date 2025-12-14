import 'package:flutter/material.dart';
import 'src/screens/inicio.dart';
import 'src/theme/app_theme.dart';

void main() {
  runApp(const AppLibros());
}

class AppLibros extends StatelessWidget {
  const AppLibros({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Libros',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.tema,
      home: const InicioScreen(),
    );
  }
}
