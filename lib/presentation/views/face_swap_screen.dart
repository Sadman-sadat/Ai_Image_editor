import 'package:flutter/material.dart';
import 'package:image_ai_editor/presentation/views/image_processing_screen.dart';
import 'package:image_ai_editor/processing_type.dart';

class FaceSwapScreen extends StatelessWidget {
  const FaceSwapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ImageProcessingScreen(
      processingType: ProcessingType.faceSwap,
    );
  }
}
