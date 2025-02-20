import 'package:appear_ai_image_editor/presentation/widgets/result_preview/result_preview_scan_line_painter.dart';
import 'package:flutter/material.dart';

class ScanningAnimationOverlay extends StatefulWidget {
  @override
  State<ScanningAnimationOverlay> createState() => _ScanningAnimationOverlayState();
}

class _ScanningAnimationOverlayState extends State<ScanningAnimationOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(  // Add ClipRRect here too
      borderRadius: BorderRadius.circular(12),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return SizedBox(
            width: 128,
            height: 128,
            child: CustomPaint(
              painter: ScanLinePainter(_animation.value),
            ),
          );
        },
      ),
    );
  }
}