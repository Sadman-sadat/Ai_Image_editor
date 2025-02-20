import 'package:appear_ai_image_editor/presentation/widgets/image_processing/image_processing_settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:appear_ai_image_editor/presentation/controllers/base64_image_conversion_controller.dart';
import 'package:appear_ai_image_editor/processing_type.dart';

class ImageProcessingAppBar extends StatefulWidget implements PreferredSizeWidget {
  final ProcessingType processingType;
  final Base64ImageConversionController controller;
  final bool? settings;

  const ImageProcessingAppBar({
    super.key,
    required this.processingType,
    required this.controller,
    this.settings,
  });

  @override
  State<ImageProcessingAppBar> createState() => _ImageProcessingAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _ImageProcessingAppBarState extends State<ImageProcessingAppBar> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          handleBackPress();
        }
      },
      child: AppBar(
        leading: GetBuilder<Base64ImageConversionController>(
          builder: (controller) => IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: handleBackPress,
          ),
        ),
        title: Text(widget.processingType.title),
        actions: [
          if (widget.settings == true)
            IconButton(
              icon: const Icon(Icons.settings),
              color: Colors.white,
              tooltip: 'Settings',
              onPressed: () => showSettingsBottomSheet(context, widget.processingType),
            ),
        ],
      ),
    );
  }

  void handleBackPress() {
    final controller = Get.find<Base64ImageConversionController>();

    if (controller.selectedImage != null) {
      controller.clearCurrentImage();
    } else {
      Get.back();
    }
  }
}
