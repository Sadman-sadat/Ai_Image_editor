import 'package:appear_ai_image_editor/presentation/controllers/image_processing_settings_controller.dart';
import 'package:appear_ai_image_editor/presentation/views/result_preview_screen.dart';
import 'package:appear_ai_image_editor/presentation/widgets/ads/rewarded_ad_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:appear_ai_image_editor/presentation/controllers/base64_image_conversion_controller.dart';
import 'package:appear_ai_image_editor/presentation/utility/app_colors.dart';
import 'package:appear_ai_image_editor/presentation/widgets/image_processing/image_processing_mask_action_buttons.dart';
import 'package:appear_ai_image_editor/presentation/widgets/image_processing/image_processing_prompt_widget.dart';
import 'package:appear_ai_image_editor/presentation/widgets/image_processing/image_processing_upload_carousel_button.dart';
import 'package:appear_ai_image_editor/processing_type.dart';
import 'package:image_picker/image_picker.dart';

class ImageProcessingActionButtons extends StatelessWidget {
  final Base64ImageConversionController imageController;
  final ProcessingType processingType;

  const ImageProcessingActionButtons({
    super.key,
    required this.imageController,
    required this.processingType,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<Base64ImageConversionController>(
      builder: (controller) {
        if (controller.selectedImage != null) {
          return _buildProcessingButtons(context);
        }
        if (processingType == ProcessingType.faceSwap) {
          return ImageProcessingUploadCarouselButtons(
            controller: imageController,
            processingType: processingType,
          );
        }
        return _buildPickButtons();
      },
    );
  }

  Widget _buildProcessingButtons(BuildContext context) {
    switch (processingType) {
      case ProcessingType.objectRemoval:
        return ImageProcessingMaskActionButtons(
          imageController: imageController,
          processingType: processingType,
        );
      case ProcessingType.headShotGen:
        return ImageProcessingPromptAction(
          controller: imageController,
          processingType: processingType,
        );
        // case ProcessingType.avatarGen:
        // return ImageProcessingPromptAction(
        //   controller: imageController,
        //   processingType: processingType,
        // );
        case ProcessingType.interiorDesignGen:
        return ImageProcessingPromptAction(
          controller: imageController,
          processingType: processingType,
        );
        case ProcessingType.relighting:
        return ImageProcessingPromptAction(
          controller: imageController,
          processingType: processingType,
        );
      case ProcessingType.faceSwap:
        return ImageProcessingUploadCarouselButtons(
            controller: imageController,
            processingType: processingType);
      default:
        return _buildUploadButton();
    }
  }

  Widget _buildPickButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildPickButton(
          icon: Icons.photo_library,
          label: 'Gallery',
          source: ImageSource.gallery,
        ),
        _buildPickButton(
          icon: Icons.camera_alt,
          label: 'Camera',
          source: ImageSource.camera,
        ),
      ],
    );
  }

  Widget _buildPickButton({
    required IconData icon,
    required String label,
    required ImageSource source,
  }) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => imageController.pickImage(source),
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
        Text(
          label,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 18),
      ],
    );
  }

  Widget _buildUploadButton() {
    final settingsController = Get.find<ImageProcessingSettingsController>();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Center(
        child: RewardedAdWidget(
          onSuccess: () {
            Get.to(() => ResultPreviewScreen(
              base64Image: imageController.processedImageUrl,
              processingType: processingType,
              maskImage: '',
              comparisonMode: settingsController.comparisonMode,
            ));
            },
          child: ElevatedButton(
            onPressed: null,
            // onPressed: () {
            //   Get.to(() => ResultPreviewScreen(
            //     base64Image: imageController.processedImageUrl,
            //     processingType: processingType,
            //     maskImage: '',
            //     comparisonMode: true,
            //   ));
            // },
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
