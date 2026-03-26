import 'dart:math' as math;
import 'package:flutter/material.dart';

class AnimatedBackground extends StatelessWidget {
  final Animation<double> rotation;
  const AnimatedBackground({super.key, required this.rotation});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: rotation,
      builder: (_, __) => Stack(children: [
        Positioned(top: -100, right: -100,
          child: Transform.rotate(
            angle: rotation.value * 2 * math.pi,
            child: Container(width: 400, height: 400,
              decoration: BoxDecoration(shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  const Color(0xFF1E40AF).withValues(alpha: 0.3), Colors.transparent]))),
          )),
        Positioned(bottom: -150, left: -150,
          child: Transform.rotate(
            angle: -rotation.value * 2 * math.pi,
            child: Container(width: 500, height: 500,
              decoration: BoxDecoration(shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  const Color(0xFF3B82F6).withValues(alpha: 0.2), Colors.transparent]))),
          )),
      ]),
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = Colors.white.withValues(alpha: 0.03)..strokeWidth = 1;
    for (double i = 0; i < size.width; i += 50)
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), p);
    for (double i = 0; i < size.height; i += 50)
      canvas.drawLine(Offset(0, i), Offset(size.width, i), p);
  }
  @override bool shouldRepaint(_) => false;
}
