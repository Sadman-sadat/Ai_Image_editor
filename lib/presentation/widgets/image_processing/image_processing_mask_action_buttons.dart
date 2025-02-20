import 'package:appear_ai_image_editor/presentation/widgets/ads/rewarded_ad_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:appear_ai_image_editor/presentation/controllers/features/base64_image_conversion_controller.dart';
import 'package:appear_ai_image_editor/presentation/controllers/features/mask_drawing_controller.dart';
import 'package:appear_ai_image_editor/presentation/utility/app_colors.dart';
import 'package:appear_ai_image_editor/presentation/views/result_preview_screen.dart';
import 'package:appear_ai_image_editor/presentation/widgets/snack_bar_message.dart';
import 'package:appear_ai_image_editor/processing_type.dart';

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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GetBuilder<MaskDrawingController>(
      init: MaskDrawingController(processingType: processingType),
      builder: (maskController) {
        if (maskController.isLoading) {
          return Padding(
            padding: EdgeInsets.symmetric(
              vertical: screenHeight * 0.02,
              horizontal: screenWidth * 0.05,
            ),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (maskController.isMaskDrawingMode) {
          return _buildMaskDrawingButtons(maskController, screenWidth, screenHeight);
        }

        if (maskController.base64MaskImage.isNotEmpty) {
          return _buildUploadButton(maskController, screenWidth, screenHeight);
        }

        return _buildStartMaskDrawingButton(maskController, screenWidth, screenHeight);
      },
    );
  }

  Widget _buildMaskDrawingButtons(
      MaskDrawingController maskController, double screenWidth, double screenHeight) {
    final buttonHeight = screenHeight * 0.06;
    final buttonWidth = (screenWidth - (screenWidth * 0.15)) / 2; // 15% total padding
    final spacing = screenWidth * 0.05;

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: screenHeight * 0.02,
        horizontal: screenWidth * 0.05,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: ElevatedButton.icon(
              onPressed: () => maskController.clearDrawPoints(),
              icon: const Icon(Icons.clear),
              label: const Text('Clear'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                fixedSize: Size(buttonWidth, buttonHeight),
              ),
            ),
          ),
          SizedBox(width: spacing),
          Flexible(
            child: ElevatedButton.icon(
              onPressed: () async {
                final maskBase64 = await maskController.generateMaskImage();
                if (maskBase64 == null) {
                  showSnackBarMessage(
                    title: 'Error',
                    message: 'Failed to generate mask',
                  );
                  return;
                }
                await maskController.uploadMaskImage(
                    imageController.base64ImageString);
              },
              icon: const Icon(Icons.check),
              label: const Text('Confirm'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                fixedSize: Size(buttonWidth, buttonHeight),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildStartMaskDrawingButton(
      MaskDrawingController maskController, double screenWidth, double screenHeight) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: screenHeight * 0.02,
        horizontal: screenWidth * 0.05,
      ),
      child: Center(
        child: SizedBox(
          height: screenHeight * 0.06,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              maskController.startMaskDrawing(
                imageSize: Size(0, 0), // Placeholder, updated in content widget
                canvasSize: Size(0, 0), // Placeholder, updated in content widget
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(screenWidth * 0.02),
              ),
              padding: EdgeInsets.zero,
            ).copyWith(
              elevation: WidgetStateProperty.all(0),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: AppColors.uploadButtonGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(screenWidth * 0.02),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.04,
                  vertical: screenHeight * 0.015,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.draw, color: Colors.white),
                    SizedBox(width: screenWidth * 0.02),
                    const Text(
                      'Draw Mask',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUploadButton(
      MaskDrawingController maskController, double screenWidth, double screenHeight) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: screenHeight * 0.02,
        horizontal: screenWidth * 0.05,
      ),
      child: Center(
        child: RewardedAdWidget(
          onSuccess: () {
            Get.to(() => ResultPreviewScreen(
                  base64Image: imageController.processedImageUrl,
                  processingType: processingType,
                  maskImage: maskController.processedMaskUrl,
                  comparisonMode: true,
                ))?.then((_) {
              maskController.resetMaskDrawing();
            });
          },
          child: ElevatedButton(
              onPressed: null,
            // ElevatedButton(
            // onPressed: () {
            //   Get.to(() => ResultPreviewScreen(
            //     base64Image: imageController.processedImageUrl,
            //     processingType: processingType,
            //     maskImage: maskController.processedMaskUrl,
            //     comparisonMode: true,
            //   ))?.then((_) {
            //     maskController.resetMaskDrawing();
            //   });
            // },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(screenWidth * 0.02),
              ),
              padding: EdgeInsets.zero,
            ).copyWith(
              elevation: WidgetStateProperty.all(0),
            ),
            child: Container(
              height: screenHeight * 0.06,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: AppColors.uploadButtonGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(screenWidth * 0.02),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/icons/ad_white.png',
                    height: screenHeight * 0.04,
                    width: screenHeight * 0.04,
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  Text(
                    'Generate ${processingType.title}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
