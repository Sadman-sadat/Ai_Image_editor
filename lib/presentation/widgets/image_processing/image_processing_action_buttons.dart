import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_ai_editor/presentation/controllers/base64_image_conversion_controller.dart';
import 'package:image_ai_editor/presentation/views/result_preview_screen.dart';
import 'package:image_ai_editor/processing_type.dart';
import 'package:image_picker/image_picker.dart';

class ImageProcessingActionButtons extends StatelessWidget {
  final Base64ImageConversionController controller;
  final ProcessingType processingType;

  const ImageProcessingActionButtons({
    super.key,
    required this.controller,
    required this.processingType,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<Base64ImageConversionController>(
      builder: (controller) {
        return controller.selectedImage != null
            ? _buildUploadButton()
            : _buildPickButtons();
      },
    );
  }

  // Method to build the camera and gallery buttons
  Widget _buildPickButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildPickButton(
            icon: Icons.photo_library,
            label: 'Gallery',
            source: ImageSource.gallery,
          ),
          _buildPickButton(
            icon: Icons.camera_alt,
            label: 'Camera',
            source: ImageSource.camera,
          ),
        ],
      ),
    );
  }

  Widget _buildPickButton({
    required IconData icon,
    required String label,
    required ImageSource source,
  }) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => controller.pickImage(source),
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(20),
          ),
          child: Icon(icon),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  // Method to build the Upload button
  Widget _buildUploadButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Center(
        child: SizedBox(
          height: 50,
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              Get.to(() => ResultPreviewScreen(
                base64Image: controller.processedImageUrl,
                processingType: processingType,
              ));
            },
            icon: const Icon(Icons.upload),
            label: Text(processingType.title),
          ),
        ),
      ),
    );
  }
}
