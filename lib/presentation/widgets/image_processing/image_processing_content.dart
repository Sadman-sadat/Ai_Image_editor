import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:appear_ai_image_editor/presentation/controllers/features/base64_image_conversion_controller.dart';
import 'package:appear_ai_image_editor/presentation/widgets/image_processing/image_processing_loading_indicator.dart';
import 'package:appear_ai_image_editor/presentation/widgets/image_processing/image_processing_mask_drawing_content.dart';
import 'package:appear_ai_image_editor/processing_type.dart';

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
        return Container(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          clipBehavior: Clip.hardEdge, // Add clipping
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            fit: StackFit.loose, // Change from expand to loose
            children: [
              Center( // Wrap CachedNetworkImage with Center
                child: CachedNetworkImage(
                  imageUrl: controller.processedImageUrl,
                  fit: BoxFit.contain,
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  placeholder: (context, url) => const ImageProcessingLoadingIndicator(
                    text: 'Loading image...',
                  ),
                  errorWidget: (context, error, stackTrace) {
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
              ),

              // Mask drawing overlay for object removal
              if (processingType == ProcessingType.objectRemoval)
                ImageProcessingMaskDrawingContent(controller: controller),
            ],
          ),
        );
      },
    );
  }
}
