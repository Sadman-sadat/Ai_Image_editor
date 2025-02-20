import 'package:appear_ai_image_editor/presentation/views/image_processing_screen.dart';
import 'package:appear_ai_image_editor/processing_type.dart';
import 'package:flutter/material.dart';

class BackgroundRemovalScreen extends StatelessWidget {
  const BackgroundRemovalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ImageProcessingScreen(
      processingType: ProcessingType.backgroundRemoval, settings: true,
    );
  }
}
