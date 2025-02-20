import 'package:appear_ai_image_editor/presentation/views/image_processing_screen.dart';
import 'package:appear_ai_image_editor/processing_type.dart';
import 'package:flutter/material.dart';

class FaceSwapScreen extends StatelessWidget {
  const FaceSwapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ImageProcessingScreen(
      processingType: ProcessingType.faceSwap,
    );
  }
}
