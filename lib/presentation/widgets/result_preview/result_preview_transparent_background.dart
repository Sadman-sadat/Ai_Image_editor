import 'package:appear_ai_image_editor/presentation/widgets/result_preview/result_preview_checkerboard_painter.dart';
import 'package:flutter/material.dart';

class ResultPreviewTransparentBackground extends StatelessWidget {
  final String imageUrl;
  final BoxFit? fit;
  final Widget Function(BuildContext, Widget, ImageChunkEvent?)? loadingBuilder;
  final Widget Function(BuildContext, Object, StackTrace?)? errorBuilder;

  const ResultPreviewTransparentBackground({
    Key? key,
    required this.imageUrl,
    this.fit,
    this.loadingBuilder,
    this.errorBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CheckerboardPainter(),
      child: Image.network(
        imageUrl,
        fit: fit,
        loadingBuilder: loadingBuilder,
        errorBuilder: errorBuilder,
      ),
    );
  }
}