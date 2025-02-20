import 'package:appear_ai_image_editor/presentation/widgets/ads/rewarded_ad_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:appear_ai_image_editor/presentation/controllers/base64_image_conversion_controller.dart';
import 'package:appear_ai_image_editor/presentation/controllers/image_processing_carousel_controller.dart';
import 'package:appear_ai_image_editor/presentation/utility/app_colors.dart';
import 'package:appear_ai_image_editor/presentation/views/result_preview_screen.dart';
import 'package:appear_ai_image_editor/processing_type.dart';
import 'package:image_picker/image_picker.dart';

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
    return GetBuilder<ImageProcessingCarouselController>(
      builder: (carouselController) => Column(
        children: [
          // Show pick buttons if no processed image yet
          if (controller.selectedImage == null)
            _buildPickButtons(controller, carouselController),

          // Show upload button if first image is picked
          if (controller.selectedImage != null && carouselController.selectedImage.isNotEmpty)
            _buildUploadButton(context, carouselController),

          // Show loading indicator while converting
          if ((carouselController.isConverting || controller.inProgress) && !carouselController.isCancelled)
          //if (carouselController.isConverting || controller.inProgress)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPickButtons(
      Base64ImageConversionController controller,
      ImageProcessingCarouselController carouselController,
      ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildPickButton(
          icon: Icons.photo_library,
          label: 'Gallery',
          source: ImageSource.gallery,
          controller: controller,
          carouselController: carouselController,
        ),
        _buildPickButton(
          icon: Icons.camera_alt,
          label: 'Camera',
          source: ImageSource.camera,
          controller: controller,
          carouselController: carouselController,
        ),
      ],
    );
  }

  Widget _buildPickButton({
    required IconData icon,
    required String label,
    required ImageSource source,
    required Base64ImageConversionController controller,
    required ImageProcessingCarouselController carouselController,
  }) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () async {
            final success = await controller.pickImage(source);
            if (success && carouselController.selectedAssetPath.isNotEmpty) {
              await carouselController.convertSelectedAsset();
            }
          },
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(18),
            backgroundColor: Colors.transparent,
          ).copyWith(
            elevation: WidgetStateProperty.all(0),
            backgroundColor: WidgetStateProperty.all(Colors.transparent),
          ),
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: AppColors.uploadButtonGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(26),
              child: Icon(icon, color: Colors.white),
            ),
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 18),
      ],
    );
  }

  Widget _buildUploadButton(BuildContext context,
      ImageProcessingCarouselController carouselController) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: 50,
        width: double.infinity,
        child: RewardedAdWidget(
          onSuccess: () {
            Get.to(() => ResultPreviewScreen(
                  base64Image: controller.processedImageUrl,
                  processingType: processingType,
                  maskImage: carouselController.selectedImage,
                  comparisonMode: false,
                ));
          },
          child: ElevatedButton(
            onPressed: null,
            // ElevatedButton(
            //   onPressed: () {
            //     Get.to(() => ResultPreviewScreen(
            //       base64Image: controller.processedImageUrl,
            //       processingType: processingType,
            //       maskImage: carouselController.selectedImage,
            //       comparisonMode: false,
            //     ));
            //   },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.zero,
            ).copyWith(
              elevation: WidgetStateProperty.all(0),
            ),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: AppColors.uploadButtonGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: 8,
                    top: 4,
                    bottom: 4,
                    child: Image.asset(
                      'assets/icons/ad_white.png',
                      height: 42,
                      width: 42,
                    ),
                  ),
                  const Center(
                    child: Text(
                      'Generate',
                      //'Generate ${processingType.title}',
                      style: TextStyle(color: Colors.white),
                    ),
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