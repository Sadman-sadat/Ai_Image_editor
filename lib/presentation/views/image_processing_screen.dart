import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_ai_editor/presentation/controllers/base64_image_conversion_controller.dart';
import 'package:image_ai_editor/presentation/widgets/image_processing/image_processing_app_bar.dart';
import 'package:image_ai_editor/presentation/widgets/image_processing/image_processing_content.dart';
import 'package:image_ai_editor/presentation/widgets/image_processing/image_processing_loading_indicator.dart';
import 'package:image_ai_editor/presentation/widgets/image_processing/image_processing_placeholder.dart';
import 'package:image_ai_editor/presentation/widgets/image_processing/image_processing_action_buttons.dart';
import 'package:image_ai_editor/processing_type.dart';

class ImageProcessingScreen extends StatefulWidget {
  final ProcessingType processingType;

  const ImageProcessingScreen({
    super.key,
    required this.processingType,
  });

  @override
  State<ImageProcessingScreen> createState() => _ImageProcessingScreenState();
}

class _ImageProcessingScreenState extends State<ImageProcessingScreen> {
  late Base64ImageConversionController base64Controller;

  @override
  void initState() {
    super.initState();
    // Use existing controller or create a new instance if not found
    base64Controller = Get.put(Base64ImageConversionController());
  }

  @override
  void dispose() {
    // Optional: Clear image when leaving the screen
    base64Controller.clearCurrentImage();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
        onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          base64Controller.clearCurrentImage();
        }
      },
      child: Scaffold(
        appBar: ImageProcessingAppBar(
          controller: base64Controller,
          processingType: widget.processingType,
        ),
        body: SafeArea(
          child: GetBuilder<Base64ImageConversionController>(
            builder: (controller) {
              if (controller.inProgress) {
                return Center(
                  child: ImageProcessingLoadingIndicator(
                    text: widget.processingType.title,
                  ),
                );
              }

              return Column(
                children: [
                  Expanded(
                    child: Center(
                      child: controller.processedImageUrl.isNotEmpty
                          ? ImageProcessingContent(controller: controller)
                          : const ImageProcessingPlaceholder(),
                    ),
                  ),
                  ImageProcessingActionButtons(
                    controller: controller,
                    processingType: widget.processingType,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
