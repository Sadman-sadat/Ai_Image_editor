import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_ai_editor/presentation/controllers/base64_image_conversion_controller.dart';
import 'package:image_ai_editor/presentation/controllers/mask_drawing_controller.dart';
import 'package:image_ai_editor/presentation/widgets/image_processing/image_processing_app_bar.dart';
import 'package:image_ai_editor/presentation/widgets/image_processing/image_processing_carousel.dart';
import 'package:image_ai_editor/presentation/widgets/image_processing/image_processing_content.dart';
import 'package:image_ai_editor/presentation/widgets/image_processing/image_processing_loading_indicator.dart';
import 'package:image_ai_editor/presentation/widgets/image_processing/image_processing_action_buttons.dart';
import 'package:image_ai_editor/presentation/widgets/image_processing/image_processing_placeholder.dart';
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
  late MaskDrawingController maskController;

  @override
  void initState() {
    super.initState();
    base64Controller = Get.find<Base64ImageConversionController>();
    maskController = Get.put(MaskDrawingController(processingType: widget.processingType));
  }

  @override
  void dispose() {
    base64Controller.clearCurrentImage();
    Get.delete<MaskDrawingController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Get.back();
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
                          ? ImageProcessingContent(
                          controller: controller,
                          processingType: widget.processingType
                      )
                          : (widget.processingType == ProcessingType.faceSwap
                          ? ImageProcessingCarousel()
                          : const ImageProcessingPlaceholder()),
                    ),
                  ),
                  ImageProcessingActionButtons(
                    imageController: controller,
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
