import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_ai_editor/presentation/views/result_preview_screen.dart';
import 'package:image_ai_editor/processing_type.dart';
import 'package:image_ai_editor/presentation/controllers/base64_image_conversion_controller.dart';

class ImageProcessingPromptField extends StatefulWidget {
  final Base64ImageConversionController controller;
  final ProcessingType processingType;

  const ImageProcessingPromptField({
    super.key,
    required this.controller,
    required this.processingType,
  });

  @override
  _ImageProcessingPromptFieldState createState() => _ImageProcessingPromptFieldState();
}

class _ImageProcessingPromptFieldState extends State<ImageProcessingPromptField> {
  String _selectedPositionLighting = 'none';
  final List<String> _positionLightingOptions = ['none', 'left', 'right', 'top', 'bottom'];

  void _navigateToResultPreview(TextEditingController promptController) {
    if (promptController.text.isNotEmpty) {
      Get.to(() => ResultPreviewScreen(
        base64Image: widget.controller.processedImageUrl,
        processingType: widget.processingType,
        textPrompt: promptController.text,
        positionLighting: _selectedPositionLighting,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController promptController = TextEditingController();

    return Column(
      children: [
        // Position Lighting Dropdown
        if (widget.processingType == ProcessingType.relighting)
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05,
              vertical: 8,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: DropdownButtonFormField<String>(
                value: _selectedPositionLighting,
                decoration: InputDecoration(
                  fillColor: Colors.purple.shade800.withOpacity(0.9),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                dropdownColor: Colors.purple.shade800,
                items: _positionLightingOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value.capitalize ?? value,
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedPositionLighting = newValue ?? 'none';
                  });
                },
              ),
            ),
          ),

        // Prompt Input Field
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.05,
            vertical: 8,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: TextFormField(
              controller: promptController,
              decoration: InputDecoration(
                hintText: widget.processingType == ProcessingType.relighting
                    ? 'Enter Relighting Generation Prompt'
                    : 'Enter Face Swap generation prompt',
                fillColor: Colors.purple.shade800.withOpacity(0.9),
                filled: true,
                prefixIcon: const Icon(Icons.generating_tokens, color: Colors.grey),
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
        ),
      ],
    );
  }
}
