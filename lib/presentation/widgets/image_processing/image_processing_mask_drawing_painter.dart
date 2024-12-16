import 'package:flutter/material.dart';

class ImageProcessingMaskDrawingPainter extends CustomPainter {
  final List<Offset> points;
  final Size imageSize;
  final Size canvasSize;
  final Rect imageBounds;
  final Size renderSize;

  ImageProcessingMaskDrawingPainter({
    required this.points,
    required this.imageSize,
    required this.canvasSize,
    required this.imageBounds,
    required this.renderSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final paint = Paint()
      ..color = Colors.white.withOpacity(0.7)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 15.0;

    // Scale points for rendering
    final scaledPoints = points.map((point) {
      final relativeX = point.dx / imageSize.width;
      final relativeY = point.dy / imageSize.height;

      return Offset(
        imageBounds.left + relativeX * renderSize.width,
        imageBounds.top + relativeY * renderSize.height,
      );
    }).toList();

    // Draw lines
    if (scaledPoints.length > 1) {
      for (int i = 0; i < scaledPoints.length - 1; i++) {
        canvas.drawLine(scaledPoints[i], scaledPoints[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant ImageProcessingMaskDrawingPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}
