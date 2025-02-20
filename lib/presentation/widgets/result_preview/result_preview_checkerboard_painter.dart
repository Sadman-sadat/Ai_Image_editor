import 'package:flutter/material.dart';

class CheckerboardPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const double squareSize = 20.0;
    final Paint paint = Paint();

    for (double y = 0; y < size.height; y += squareSize) {
      for (double x = 0; x < size.width; x += squareSize) {
        paint.color = (x ~/ squareSize % 2 == y ~/ squareSize % 2)
            ? Colors.white
            : Colors.grey.withOpacity(0.3);
        canvas.drawRect(
            Rect.fromLTWH(x, y, squareSize, squareSize), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
