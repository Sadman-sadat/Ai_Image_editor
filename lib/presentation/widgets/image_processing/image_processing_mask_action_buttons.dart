import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_ai_editor/presentation/controllers/base64_image_conversion_controller.dart';
import 'package:image_ai_editor/presentation/controllers/mask_drawing_controller.dart';
import 'package:image_ai_editor/presentation/views/result_preview_screen.dart';
import 'package:image_ai_editor/presentation/widgets/snack_bar_message.dart';
import 'package:image_ai_editor/processing_type.dart';

class ImageProcessingMaskActionButtons extends StatelessWidget {
  final Base64ImageConversionController imageController;
  final ProcessingType processingType;

  const ImageProcessingMaskActionButtons({
    super.key,
    required this.imageController,
    required this.processingType,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MaskDrawingController>(
      init: MaskDrawingController(processingType: processingType),
      builder: (maskController) {
        // Different UI states for mask drawing
        if (maskController.isMaskDrawingMode) {
          return _buildMaskDrawingButtons(maskController);
        }

        if (maskController.base64MaskImage.isNotEmpty) {
          return _buildUploadButton(maskController);
        }

        return _buildStartMaskDrawingButton(maskController);
      },
    );
  }

  Widget _buildMaskDrawingButtons(MaskDrawingController maskController) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton.icon(
            onPressed: () => maskController.clearDrawPoints(),
            icon: const Icon(Icons.clear),
            label: const Text('Clear Mask'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              final maskBase64 = await maskController.generateMaskImage();

              if (maskBase64 == null) {
                showSnackBarMessage(
                  title: 'Error',
                  message: 'Failed to generate mask',
                );
                return;
              }

              final success = await maskController.uploadMaskImage(
                  imageController.base64ImageString
              );

              if (success) {
                maskController.update();
              }
            },
            icon: const Icon(Icons.check),
            label: const Text('Confirm Mask'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          ),
        ],
      ),
    );
  }

  Widget _buildStartMaskDrawingButton(MaskDrawingController maskController) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Center(
        child: ElevatedButton.icon(
          onPressed: () {
            maskController.startMaskDrawing(
              imageSize: Size(0, 0), // Placeholder, updated in content widget
              canvasSize: Size(0, 0), // Placeholder, updated in content widget
            );
          },
          icon: const Icon(Icons.draw),
          label: const Text('Draw Mask'),
        ),
      ),
    );
  }

  Widget _buildUploadButton(MaskDrawingController maskController) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Center(
        child: SizedBox(
          height: 50,
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              Get.to(() => ResultPreviewScreen(
                base64Image: imageController.processedImageUrl,
                processingType: processingType,
                maskImage: maskController.processedMaskUrl,
                comparisonMode: true,
              ))?.then((_) {
                // After returning from the result preview screen
                maskController.resetMaskDrawing();
              });
            },
            icon: const Icon(Icons.upload),
            label: Text(processingType.title),
          ),
        ),
      ),
    );
  }
}