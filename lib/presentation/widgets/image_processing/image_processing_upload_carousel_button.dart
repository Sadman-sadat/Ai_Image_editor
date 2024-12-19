import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_ai_editor/presentation/controllers/base64_image_conversion_controller.dart';
import 'package:image_ai_editor/presentation/controllers/image_processing_carousel_controller.dart';
import 'package:image_ai_editor/presentation/views/result_preview_screen.dart';
import 'package:image_ai_editor/processing_type.dart';

class ImageProcessingUploadCarouselButtons extends StatelessWidget {
  final Base64ImageConversionController controller;
  final ProcessingType processingType;

  const ImageProcessingUploadCarouselButtons({
    super.key,
    required this.controller,
    required this.processingType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Center(
        child: SizedBox(
          height: 50,
          width: double.infinity,
          child: GetBuilder<ImageProcessingCarouselController>(
            builder: (carouselController) => ElevatedButton.icon(
              onPressed: carouselController.selectedImage.isEmpty
                  ? null
                  : () {
                Get.to(() => ResultPreviewScreen(
                  base64Image: controller.processedImageUrl,
                  processingType: processingType,
                  maskImage: carouselController.selectedImage,
                  comparisonMode: false,
                ));
              },
              icon: const Icon(Icons.upload),
              label: Text(processingType.title),
            ),
          ),
        ),
      ),
    );
  }
}