import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:appear_ai_image_editor/presentation/controllers/features/base64_image_conversion_controller.dart';
import 'package:appear_ai_image_editor/presentation/controllers/features/mask_drawing_controller.dart';
import 'package:appear_ai_image_editor/presentation/widgets/image_processing/image_processing_mask_drawing_painter.dart';

class ImageProcessingMaskDrawingContent extends StatelessWidget {
  final Base64ImageConversionController controller;

  const ImageProcessingMaskDrawingContent({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MaskDrawingController>(
      builder: (maskController) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return GestureDetector(
              onPanStart: (details) {
                final RenderBox renderBox = context.findRenderObject() as RenderBox;
                final imageBox = context.findAncestorRenderObjectOfType<RenderBox>()!;

                // Get image size and position
                final imageProvider = Image.network(controller.processedImageUrl).image;
                imageProvider.resolve(ImageConfiguration()).addListener(
                  ImageStreamListener((ImageInfo info, bool _) {
                    // Get actual image dimensions
                    final imageWidth = info.image.width.toDouble();
                    final imageHeight = info.image.height.toDouble();

                    // Calculate image's render size while maintaining aspect ratio
                    double renderWidth, renderHeight;
                    final double aspectRatio = imageWidth / imageHeight;

                    if (imageBox.size.width / imageBox.size.height > aspectRatio) {
                      // Image is constrained by height
                      renderHeight = imageBox.size.height;
                      renderWidth = renderHeight * aspectRatio;
                    } else {
                      // Image is constrained by width
                      renderWidth = imageBox.size.width;
                      renderHeight = renderWidth / aspectRatio;
                    }

                    // Calculate image offset and size
                    final imagePosition = imageBox.localToGlobal(Offset.zero);
                    final canvasPosition = renderBox.localToGlobal(Offset.zero);
                    final imageOffset = imagePosition - canvasPosition;

                    // Create image bounds
                    final imageBounds = Rect.fromLTWH(
                      imageOffset.dx + (imageBox.size.width - renderWidth) / 2,
                      imageOffset.dy + (imageBox.size.height - renderHeight) / 2,
                      renderWidth,
                      renderHeight,
                    );

                    maskController.startMaskDrawing(
                      imageSize: Size(imageWidth, imageHeight),
                      canvasSize: renderBox.size,
                      imageOffset: imageOffset,
                      imageBounds: imageBounds,
                      renderSize: Size(renderWidth, renderHeight),
                    );
                  }),
                );
              },
              onPanUpdate: (details) {
                final RenderBox renderBox = context.findRenderObject() as RenderBox;
                final localPosition = renderBox.globalToLocal(details.globalPosition);

                maskController.addDrawPoint(localPosition);
              },
              child: CustomPaint(
                painter: ImageProcessingMaskDrawingPainter(
                  points: maskController.drawPoints,
                  imageSize: maskController.imageSize ?? Size.zero,
                  canvasSize: maskController.canvasSize ?? Size.zero,
                  imageBounds: maskController.imageBounds ?? Rect.zero,
                  renderSize: maskController.renderSize ?? Size.zero,
                ),
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
