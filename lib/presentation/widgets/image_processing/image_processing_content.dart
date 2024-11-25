import 'package:flutter/material.dart';
import 'package:image_ai_editor/presentation/controllers/base64_image_conversion_controller.dart';
import 'package:image_ai_editor/presentation/widgets/image_processing/image_processing_placeholder.dart';

class ProcessedImageDisplay extends StatelessWidget {
  final Base64ImageConversionController controller;

  const ProcessedImageDisplay({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      controller.processedImageUrl.value,
      fit: BoxFit.contain,
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.6,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return const ImageLoadingIndicator(
          text: 'Loading image...',
        );
      },
    );
  }
}