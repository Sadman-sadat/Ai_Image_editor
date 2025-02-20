import 'package:appear_ai_image_editor/data/services/subscription_service.dart';
import 'package:appear_ai_image_editor/presentation/controllers/image_processing/image_processing_settings_controller.dart';
import 'package:appear_ai_image_editor/presentation/utility/app_colors.dart';
import 'package:appear_ai_image_editor/processing_type.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showSettingsBottomSheet(BuildContext context, ProcessingType processingType) {
  final screenHeight = MediaQuery.of(context).size.height;
  final controller = Get.find<ImageProcessingSettingsController>();
  final subscriptionService = SubscriptionService.to;

  Get.bottomSheet<Map<String, dynamic>>(
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: screenHeight * 0.8,
        ),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: AppColors.cardSetting,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Settings',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                ),
              ),
            ),
            const Divider(color: Colors.white24),
            const SizedBox(height: 16),

            // Fixed Comparison Mode
            GetBuilder<ImageProcessingSettingsController>(
              builder: (controller) => SwitchListTile(
                title: const Text(
                  'Comparison Mode',
                  style: TextStyle(color: Colors.white),
                ),
                value: controller.comparisonMode,
                onChanged: (value) {
                  controller.toggleComparisonMode(value);
                },
                activeColor: AppColors.uploadButtonGradient[1],
              ),
            ),

            // Transparent Mode
            // if (processingType == ProcessingType.backgroundRemoval)
            //   GetBuilder<ImageProcessingSettingsController>(
            //     builder: (controller) => SwitchListTile(
            //       title: const Text(
            //         'Transparent Mode',
            //         style: TextStyle(color: Colors.white),
            //       ),
            //       value: controller.transparentMode,
            //       onChanged: controller.toggleTransparentMode,
            //       activeColor: AppColors.uploadButtonGradient[1],
            //     ),
            //   ),

            if (processingType == ProcessingType.imageEnhancement)
              GetBuilder<ImageProcessingSettingsController>(
                builder: (controller) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Scale:',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500
                                ),
                              ),
                              const Spacer(),
                              _buildScaleBadge(
                                '2x',
                                isActive: true,
                                isAvailable: true,
                              ),
                              const SizedBox(width: 8),
                              _buildScaleBadge(
                                '3x',
                                isActive: controller.scale >= 3.0,
                                isAvailable: subscriptionService.hasSubscription(),
                                subscriptionType: 'SUB',
                              ),
                              const SizedBox(width: 8),
                              _buildScaleBadge(
                                '4x',
                                isActive: controller.scale >= 4.0,
                                isAvailable: subscriptionService.isVip(),
                                subscriptionType: 'VIP',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Slider(
                      value: controller.scale,
                      min: 2.0,
                      max: 4.0,
                      divisions: 2,
                      label: '${controller.scale.toInt()}x',
                      onChanged: controller.updateScale,
                      activeColor: AppColors.uploadButtonGradient[1],
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 16),

            Center(
              child: ElevatedButton(
                onPressed: () {
                  final settings = {
                    'comparisonMode': controller.comparisonMode,
                    // comment out to bring back transparentMode
                    // if (processingType == ProcessingType.backgroundRemoval)
                    //   'transparentMode': controller.transparentMode,
                    if (processingType == ProcessingType.imageEnhancement)
                      'scale': controller.scale,
                  };
                  Get.back(result: settings);
                },
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
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: AppColors.uploadButtonGradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'Apply',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    isScrollControlled: true,
  );
}

Widget _buildScaleBadge(
    String scale, {
      required bool isActive,
      required bool isAvailable,
      String? subscriptionType,
    }) {
  String tooltipMessage = '';
  switch (scale) {
    case '2x':
      tooltipMessage = 'Standard enhancement (2x) - Available for all users';
      break;
    case '3x':
      tooltipMessage = 'Advanced enhancement (3x) - Available with Premium subscription';
      break;
    case '4x':
      tooltipMessage = 'Maximum enhancement (4x) - Exclusive to VIP members';
      break;
  }

  return Tooltip(
    message: tooltipMessage,
    verticalOffset: -40,
    decoration: BoxDecoration(
      color: Colors.black87,
      borderRadius: BorderRadius.circular(8),
    ),
    textStyle: const TextStyle(
      color: Colors.white,
      fontSize: 12,
    ),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: isActive && isAvailable
            ? const LinearGradient(
          colors: AppColors.uploadButtonGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )
            : null,
        color: isAvailable
            ? Colors.white.withOpacity(0.1)
            : Colors.white.withOpacity(0.05),
        border: Border.all(
          color: isAvailable
              ? Colors.white.withOpacity(0.2)
              : Colors.white.withOpacity(0.1),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            scale,
            style: TextStyle(
              color: isAvailable ? Colors.white : Colors.white.withOpacity(0.5),
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          if (subscriptionType != null) ...[
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: subscriptionType == 'VIP'
                    ? Colors.amber.withOpacity(0.2)
                    : Colors.blue.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                subscriptionType,
                style: TextStyle(
                  color: subscriptionType == 'VIP'
                      ? Colors.amber
                      : Colors.blue,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    ),
  );
}
