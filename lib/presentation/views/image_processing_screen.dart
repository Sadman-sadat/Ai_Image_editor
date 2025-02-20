import 'package:appear_ai_image_editor/presentation/controllers/image_processing_settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:appear_ai_image_editor/presentation/controllers/base64_image_conversion_controller.dart';
import 'package:appear_ai_image_editor/presentation/controllers/mask_drawing_controller.dart';
import 'package:appear_ai_image_editor/presentation/widgets/image_processing/image_processing_app_bar.dart';
import 'package:appear_ai_image_editor/presentation/widgets/image_processing/image_processing_carousel.dart';
import 'package:appear_ai_image_editor/presentation/widgets/image_processing/image_processing_content.dart';
import 'package:appear_ai_image_editor/presentation/widgets/image_processing/image_processing_loading_indicator.dart';
import 'package:appear_ai_image_editor/presentation/widgets/image_processing/image_processing_action_buttons.dart';
import 'package:appear_ai_image_editor/presentation/widgets/image_processing/image_processing_placeholder.dart';
import 'package:appear_ai_image_editor/processing_type.dart';

class ImageProcessingScreen extends StatefulWidget {
  final ProcessingType processingType;
  final bool? settings;

  const ImageProcessingScreen({
    super.key,
    required this.processingType, this.settings,
  });

  @override
  State<ImageProcessingScreen> createState() => _ImageProcessingScreenState();
}

class _ImageProcessingScreenState extends State<ImageProcessingScreen> {
  late Base64ImageConversionController base64Controller;
  late MaskDrawingController maskController;

  @override
  void initState() {
    super.initState();
    base64Controller = Get.find<Base64ImageConversionController>();
    maskController = Get.put(MaskDrawingController(processingType: widget.processingType));

    if (!Get.isRegistered<ImageProcessingSettingsController>()) {
      Get.put(ImageProcessingSettingsController());
    }
  }

  @override
  void dispose() {
    base64Controller.clearCurrentImage();
    Get.delete<MaskDrawingController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ImageProcessingAppBar(
        controller: base64Controller,
        processingType: widget.processingType,
        settings: widget.settings,
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
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
                          ? ImageProcessingContent(
                          controller: controller,
                          processingType: widget.processingType
                      )
                          : (widget.processingType == ProcessingType.faceSwap
                          ? ImageProcessingCarousel()
                          : const ImageProcessingPlaceholder()),
                    ),
                  ),

                  Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: Colors.grey, // Adjust color as needed
                          width: 0.5,
                        ),
                      ),
                    ),
                    child: ImageProcessingActionButtons(
                      imageController: controller,
                      processingType: widget.processingType,
                    ),
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
