import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_ai_editor/presentation/views/result_preview_screen.dart';
import 'package:image_ai_editor/processing_type.dart';
import 'package:image_ai_editor/presentation/controllers/base64_image_conversion_controller.dart';

class ImageProcessingPromptField extends StatelessWidget {
  final Base64ImageConversionController controller;
  final ProcessingType processingType;

  const ImageProcessingPromptField({
    super.key,
    required this.controller,
    required this.processingType,
  });

  void _navigateToResultPreview(TextEditingController promptController) {
    if (promptController.text.isNotEmpty) {
      Get.to(() => ResultPreviewScreen(
        base64Image: controller.processedImageUrl,
        processingType: processingType,
        textPrompt: promptController.text,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController promptController = TextEditingController();

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.05,
        vertical: 8,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: TextFormField(
          controller: promptController,
          decoration: InputDecoration(
            hintText: 'Enter Face Swap generation prompt',
            fillColor: Colors.purple.shade800.withOpacity(0.9),
            filled: true,
            prefixIcon: const Icon(Icons.generating_tokens, color: Colors.grey,),
            suffixIcon: IconButton(
              icon: const Icon(Icons.send, color: Colors.grey),
              onPressed: () => _navigateToResultPreview(promptController),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
          onFieldSubmitted: (_) => _navigateToResultPreview(promptController),
        ),
      ),
    );
  }
}
