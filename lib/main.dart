import 'dart:math';
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
      theme: AppTheme.navidadTheme,
      // Aplicamos SnowWrapper a toda la app
      home: const SnowWrapper(child: InicioScreen()),
      builder: (context, child) {
        // Esto permite que todas las rutas tengan nieve sin reiniciar la animación
        return SnowWrapper(child: child!);
      },
    );
  }
}

/// Widget que envuelve cualquier pantalla y agrega nieve animada
class SnowWrapper extends StatelessWidget {
  final Widget child;

  const SnowWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [child, const Snowfall()]);
  }
}

/// Animación de nieve simple
class Snowfall extends StatefulWidget {
  const Snowfall({super.key});

  @override
  State<Snowfall> createState() => _SnowfallState();
}

class _SnowfallState extends State<Snowfall>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final Random _random = Random();
  final int _numFlakes = 50;
  late final List<double> _xPos;
  late final List<double> _yPos;
  late final List<double> _size;

  @override
  void initState() {
    super.initState();
    _xPos = List.generate(_numFlakes, (_) => _random.nextDouble());
    _yPos = List.generate(_numFlakes, (_) => _random.nextDouble());
    _size = List.generate(_numFlakes, (_) => _random.nextDouble() * 4 + 2);

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30), // más lento
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: true, // Los botones siguen funcionando
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            size: MediaQuery.of(context).size,
            painter: SnowPainter(
              xPos: _xPos,
              yPos: _yPos.map((y) => (y + _controller.value) % 1.0).toList(),
              size: _size,
            ),
          );
        },
      ),
    );
  }
}

class SnowPainter extends CustomPainter {
  final List<double> xPos;
  final List<double> yPos;
  final List<double> size;

  SnowPainter({required this.xPos, required this.yPos, required this.size});

  @override
  void paint(Canvas canvas, Size s) {
    final paint = Paint()..color = Colors.white;
    for (int i = 0; i < xPos.length; i++) {
      final dx = xPos[i] * s.width;
      final dy = yPos[i] * s.height;
      canvas.drawCircle(Offset(dx, dy), size[i], paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
