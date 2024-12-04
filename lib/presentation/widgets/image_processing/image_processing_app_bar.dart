import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_ai_editor/presentation/controllers/base64_image_conversion_controller.dart';
import 'package:image_ai_editor/processing_type.dart';

class ImageProcessingAppBar extends StatelessWidget implements PreferredSizeWidget {
  final ProcessingType processingType;
  final Base64ImageConversionController controller;

  const ImageProcessingAppBar({
    super.key,
    required this.processingType,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(processingType.title),
      actions: [
        GetBuilder<Base64ImageConversionController>(
          builder: (controller) {
            return controller.selectedImage != null &&
                !controller.inProgress
                ? IconButton(
              icon: const Icon(Icons.clear),
              onPressed: controller.clearCurrentImage,
            )
                : const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
