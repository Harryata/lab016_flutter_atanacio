import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get tema {
    return ThemeData(
      primarySwatch: Colors.indigo,
      scaffoldBackgroundColor: Colors.grey[100],
      appBarTheme: const AppBarTheme(centerTitle: true),
    );
  }
}
