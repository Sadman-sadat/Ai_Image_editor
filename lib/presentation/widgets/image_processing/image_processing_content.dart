import 'package:flutter/material.dart';
import 'package:image_ai_editor/presentation/controllers/base64_image_conversion_controller.dart';
import 'package:image_ai_editor/presentation/widgets/image_processing/image_processing_loading_indicator.dart';
import 'package:image_ai_editor/presentation/widgets/image_processing/image_processing_mask_drawing_content.dart';
import 'package:image_ai_editor/processing_type.dart';

class ImageProcessingContent extends StatelessWidget {
  final Base64ImageConversionController controller;
  final ProcessingType processingType;

  const ImageProcessingContent({
    super.key,
    required this.controller,
    required this.processingType,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              controller.processedImageUrl,
              fit: BoxFit.contain,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const ImageProcessingLoadingIndicator(
                  text: 'Loading image...',
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load image',
                      style: TextStyle(color: Colors.red[700]),
                    ),
                  ],
                );
              },
            ),

            // Mask drawing overlay for object removal
            if (processingType == ProcessingType.objectRemoval)
              ImageProcessingMaskDrawingContent(controller: controller),
          ],
        );
      },
    );
  }
}
