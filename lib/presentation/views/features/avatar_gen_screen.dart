import 'package:appear_ai_image_editor/presentation/views/image_processing_screen.dart';
import 'package:appear_ai_image_editor/processing_type.dart';
import 'package:flutter/material.dart';

class AvatarGenScreen extends StatelessWidget {
  const AvatarGenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ImageProcessingScreen(
      processingType: ProcessingType.avatarGen,
    );
  }
}
