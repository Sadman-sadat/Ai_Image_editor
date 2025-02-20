import 'package:appear_ai_image_editor/presentation/controllers/image_processing/image_processing_prompt_action_controller.dart';
import 'package:appear_ai_image_editor/presentation/utility/app_colors.dart';
import 'package:appear_ai_image_editor/presentation/widgets/ads/rewarded_ad_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:appear_ai_image_editor/presentation/views/result_preview_screen.dart';
import 'package:appear_ai_image_editor/processing_type.dart';
import 'package:appear_ai_image_editor/presentation/controllers/features/base64_image_conversion_controller.dart';

class ImageProcessingPromptAction extends StatefulWidget {
  static const double actionAreaHeight = 200.0;
  static const double inputHeight = 80.0;
  static const double buttonHeight = 50.0;

  final Base64ImageConversionController controller;
  final ProcessingType processingType;

  const ImageProcessingPromptAction({
    super.key,
    required this.controller,
    required this.processingType,
  });

  @override
  State<ImageProcessingPromptAction> createState() => _ImageProcessingPromptActionState();
}

class _ImageProcessingPromptActionState extends State<ImageProcessingPromptAction> {
  late final TextEditingController textController;
  late final ImageProcessingPromptActionController promptController;

  @override
  void initState() {
    super.initState();
    promptController = Get.put(
      ImageProcessingPromptActionController(processingType: widget.processingType),
      tag: widget.processingType.toString(),
    );
    textController = TextEditingController(text: promptController.promptText);
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  String _getHintText(ProcessingType processingType) {
    switch (processingType) {
      case ProcessingType.relighting:
        return 'E.g: Purple neon lights';
      case ProcessingType.interiorDesignGen:
        return 'Orange wall color, Modern style';
      case ProcessingType.headShotGen:
        return 'On sea Beach, with my Sports car';
      case ProcessingType.avatarGen:
        return 'E.g: Cute, Cartoon';
      default:
        return 'Enter Prompt';
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: constraints.maxWidth * 0.05,
          ),
          child: SizedBox(
            height: ImageProcessingPromptAction.actionAreaHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Prompt Row
                SizedBox(
                  height: ImageProcessingPromptAction.inputHeight,
                  child: Row(
                    children: [
                      // Prompt Input Field
                      Expanded(
                        flex: widget.processingType == ProcessingType.relighting ? 2 : 1,
                        child: Container(
                          height: ImageProcessingPromptAction.inputHeight,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: AppColors.uploadButtonGradient,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextFormField(
                            controller: textController,
                            onChanged: promptController.setPromptText,
                            maxLines: 3,
                            minLines: 1,
                            decoration: InputDecoration(
                              hintText: _getHintText(widget.processingType),
                              fillColor: Colors.transparent,
                              filled: true,
                              prefixIcon: const Padding(
                                padding: EdgeInsets.only(left: 22.0, right: 12.0),
                                child: Icon(
                                  Icons.generating_tokens,
                                  color: Colors.white,
                                  size: 32,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                              constraints: const BoxConstraints.expand(height: ImageProcessingPromptAction.inputHeight),
                            ),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),

                      if (widget.processingType == ProcessingType.relighting) ...[
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: ImageProcessingPromptAction.inputHeight,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: AppColors.uploadButtonGradient,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: _buildDropdown(),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Generate Button
                GetBuilder<ImageProcessingPromptActionController>(
                  tag: widget.processingType.toString(),
                  builder: (controller) => SizedBox(
                    height: ImageProcessingPromptAction.buttonHeight,
                    child: AbsorbPointer(
                      absorbing: !controller.isValid,
                      child: RewardedAdWidget(
                        onSuccess: () {
                          Get.to(() => ResultPreviewScreen(
                            base64Image: widget.controller.processedImageUrl,
                            processingType: widget.processingType,
                            textPrompt: controller.promptText,
                            positionLighting: controller.selectedPositionLighting,
                          ));
                        },
                        child: ElevatedButton(
                          onPressed: null,
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
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: controller.isValid
                                    ? AppColors.uploadButtonGradient
                                    : [Colors.grey, Colors.grey.shade700],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Image.asset(
                                      'assets/icons/ad_white.png',
                                      height: 42,
                                      width: 42,
                                    ),
                                  ),
                                  const Text(
                                    'Generate',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDropdown() {
    return Center(
      child: GetBuilder<ImageProcessingPromptActionController>(
        tag: widget.processingType.toString(),
        builder: (controller) => DropdownButtonFormField<String>(
          value: controller.selectedPositionLighting,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.transparent,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            constraints: const BoxConstraints.expand(height: ImageProcessingPromptAction.inputHeight),
          ),
          dropdownColor: AppColors.uploadButtonGradient.last,
          items: controller.positionLightingOptions.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value.capitalize ?? value,
                style: const TextStyle(color: Colors.white),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            controller.setPositionLighting(newValue ?? 'none');
          },
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
        ),
      ),
    );
  }
}
