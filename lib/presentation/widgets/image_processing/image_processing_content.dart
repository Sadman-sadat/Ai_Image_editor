import 'package:flutter/material.dart';
import 'package:image_ai_editor/presentation/controllers/base64_image_conversion_controller.dart';
import 'package:image_ai_editor/presentation/widgets/image_processing/image_processing_loading_indicator.dart';

class ImageProcessingContent extends StatelessWidget {
  final Base64ImageConversionController controller;

  const ImageProcessingContent({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      controller.processedImageUrl,
      fit: BoxFit.contain,
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.6,
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
    );
  }
}
