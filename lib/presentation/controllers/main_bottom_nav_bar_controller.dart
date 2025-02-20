import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:appear_ai_image_editor/data/services/feature_usage_service.dart';
import 'package:appear_ai_image_editor/data/services/subscription_service.dart';
import 'package:appear_ai_image_editor/presentation/views/home_screen.dart';
import 'package:appear_ai_image_editor/presentation/views/social_media_screen.dart';
import 'package:appear_ai_image_editor/presentation/views/subscription_screen.dart';
import 'package:appear_ai_image_editor/presentation/controllers/ads/ad_controller.dart';

class MainBottomNavBarController extends GetxController {
  int selectedIndex = 0;
  bool isInitialized = false;
  List<Widget> screens = [];

  late final SubscriptionService subscriptionService;
  late final FeatureUsageService featureUsageService;
  late final AdController adController;

  @override
  void onInit() {
    super.onInit();
    initializeServices();
  }

  Future<void> initializeServices() async {
    adController = Get.find<AdController>();
    adController.initializeControllers();

    subscriptionService = await SubscriptionService.init();
    featureUsageService = await FeatureUsageService.init();

    screens = [
      HomeScreen(
        subscriptionService: subscriptionService,
        featureUsageService: featureUsageService,
      ),
      const SocialMediaScreen(),
      const SubscriptionScreen(),
    ];

    isInitialized = true;
    update();
  }

  void changeIndex(int index) {
    selectedIndex = index;
    update();
  }
}
