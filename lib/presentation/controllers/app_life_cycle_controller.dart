import 'package:appear_ai_image_editor/presentation/controllers/features/avatar_gen_controller.dart';
import 'package:appear_ai_image_editor/presentation/controllers/features/background_removal_controller.dart';
import 'package:appear_ai_image_editor/presentation/controllers/features/base64_image_conversion_controller.dart';
import 'package:appear_ai_image_editor/presentation/controllers/features/face_swap_controller.dart';
import 'package:appear_ai_image_editor/presentation/controllers/features/head_shot_gen_controller.dart';
import 'package:appear_ai_image_editor/presentation/controllers/features/image_enhancement_controller.dart';
import 'package:appear_ai_image_editor/presentation/controllers/features/interior_design_controller.dart';
import 'package:appear_ai_image_editor/presentation/controllers/features/object_removal_controller.dart';
import 'package:appear_ai_image_editor/presentation/controllers/features/relighting_controller.dart';
import 'package:appear_ai_image_editor/presentation/controllers/home_screen_controller.dart';
import 'package:appear_ai_image_editor/presentation/controllers/image_processing/image_processing_carousel_controller.dart';
import 'package:appear_ai_image_editor/presentation/controllers/main_bottom_nav_bar_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppLifecycleController extends GetxController with WidgetsBindingObserver {
  bool _appPaused = false;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused) {
      _appPaused = true;
    } else if (state == AppLifecycleState.resumed && _appPaused) {
      _appPaused = false;
      // Trigger rebuild of all controllers
      _rebuildControllers();
    }
  }

  void _rebuildControllers() {
    // Force update on critical controllers that manage UI elements
    try {
      // Add more aggressive UI refresh when resuming
      Get.forceAppUpdate(); // Add this line to force a complete app refresh

      // Update any active feature controller
      _updateFeatureControllers();

      // Specifically update UI-related controllers
      if (Get.isRegistered<MainBottomNavBarController>()) {
        Get.find<MainBottomNavBarController>().update();
      }

      if (Get.isRegistered<HomeScreenController>()) {
        Get.find<HomeScreenController>().update();
      }

      if (Get.isRegistered<ImageProcessingCarouselController>()) {
        Get.find<ImageProcessingCarouselController>().update();
      }

      if (Get.isRegistered<Base64ImageConversionController>()) {
        Get.find<Base64ImageConversionController>().update();
      }

      // Force MaterialApp to rebuild
      Get.rootController.update();

    } catch (e) {
      print('Error rebuilding controllers: $e');
    }
  }

  void _updateFeatureControllers() {
    final controllers = [
      BackgroundRemovalController,
      FaceSwapController,
      HeadShotGenController,
      AvatarGenController,
      InteriorDesignController,
      RelightingController,
      ObjectRemovalController,
      ImageEnhancementController,
    ];

    for (var controllerType in controllers) {
      try {
        if (Get.isRegistered(tag: controllerType.toString())) {
          Get.find(tag: controllerType.toString()).update();
        }
      } catch (e) {
        // Skip if controller not found or can't be updated
      }
    }
  }
}