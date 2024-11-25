import 'package:flutter/material.dart';
import 'package:image_ai_editor/presentation/views/image_processing_screen.dart';
import 'package:image_ai_editor/processing_type.dart';

class ImageEnhancementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ImageProcessingScreen(
      processingType: ProcessingType.imageEnhancement,
    );
  }
}
