import 'package:appear_ai_image_editor/data/services/subscription_service.dart';
import 'package:appear_ai_image_editor/presentation/controllers/ads/ad_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class SplashController extends GetxController with GetTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  int currentImageIndex = 0;
  int nextImageIndex = 1;
  bool isAdsInitialized = false;
  bool isInitialized = false;

  final List<String> imageAssets = [
    'assets/splash/image_1.jpeg',
    'assets/splash/image_2.jpg',
    'assets/splash/Image_3.jpg',
    'assets/splash/image_4.jpg',
    'assets/splash/image_5.jpg',
    'assets/splash/image_6.jpg',
  ];

  @override
  void onInit() {
    super.onInit();
    initializeAnimation();
    startImageTransition();
    _initializeServices();
  }

  void initializeAnimation() {
    animationController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );

    animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  void startImageTransition() {
    animationController.forward();

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        currentImageIndex = nextImageIndex;
        nextImageIndex = (nextImageIndex + 1) % imageAssets.length;
        animationController.reset();
        animationController.forward();
        update();
      }
    });
  }

  Future<void> _initializeServices() async {
    try {
      // Initialize Mobile Ads SDK
      await MobileAds.instance.initialize();

      // Initialize subscription service
      final subscriptionService = await SubscriptionService.init();
      await subscriptionService.getSubscriptionStatus();
      Get.put(subscriptionService);

      // Pre-load first ads
      final mainController = Get.find<AdController>();
      mainController.initializeAds();

      isInitialized = true;
      update();
    } catch (e) {
      debugPrint('Error initializing services: $e');
      // Still set to true so we don't block the user
      isInitialized = true;
      update();
    }
  }


  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}
