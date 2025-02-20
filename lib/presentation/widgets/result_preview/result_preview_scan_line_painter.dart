import 'package:flutter/material.dart';

class ScanLinePainter extends CustomPainter {
  final double position;

  ScanLinePainter(this.position);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..strokeWidth = 12.0
      ..strokeCap = StrokeCap.round;

    final x = size.width * position;
    canvas.drawLine(
      Offset(x, 0),
      Offset(x, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(ScanLinePainter oldDelegate) => true;
}