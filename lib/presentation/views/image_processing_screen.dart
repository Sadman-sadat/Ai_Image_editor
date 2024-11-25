
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_ai_editor/presentation/controllers/base64_image_conversion_controller.dart';
import 'package:image_ai_editor/presentation/widgets/image_processing/image_processing_action_buttons.dart';
import 'package:image_ai_editor/presentation/widgets/image_processing/image_processing_app_bar.dart';
import 'package:image_ai_editor/presentation/widgets/image_processing/image_processing_content.dart';
import 'package:image_ai_editor/presentation/widgets/image_processing/image_processing_loading_indicator.dart';
import 'package:image_ai_editor/presentation/widgets/image_processing/image_processing_placeholder.dart';
import 'package:image_ai_editor/processing_type.dart';

class ImageProcessingScreen extends StatelessWidget {
  final ProcessingType processingType;

  const ImageProcessingScreen({
    super.key,
    required this.processingType,
  });

  @override
  Widget build(BuildContext context) {
    final Base64ImageConversionController base64Controller =
    Get.put(Base64ImageConversionController());

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          base64Controller.clearCurrentImage();
        }
      },
      child: Scaffold(
        appBar: ImageProcessingAppBar(
          controller: base64Controller,
          processingType: processingType,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Obx(() {
                    if (base64Controller.isLoading.value) {
                      return const ImageLoadingIndicator(
                        text: 'Uploading image...',
                      );
                    }
                    return base64Controller.processedImageUrl.isNotEmpty
                        ? ProcessedImageDisplay(controller: base64Controller)
                        : const ImagePlaceholder();
                  }),
                ),
              ),
              ImageActionButtons(
                controller: base64Controller,
                processingType: processingType,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
