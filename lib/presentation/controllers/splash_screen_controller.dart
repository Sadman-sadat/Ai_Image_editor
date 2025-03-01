import 'package:appear_ai_image_editor/data/services/consent_service.dart';
import 'package:appear_ai_image_editor/data/services/subscription_service.dart';
import 'package:appear_ai_image_editor/presentation/controllers/ads/ad_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class SplashController extends GetxController with GetTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;
  late ConsentService consentService;

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
    // Get the already initialized ConsentService
    consentService = Get.find<ConsentService>();
    if (!consentService.isConsentComplete) {
      _initializeServices();
    } else {
      _completeInitialization();
    }
    _setupConsentListener();
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

  void _setupConsentListener() {
    // Set up a ticker to check consent service status until it's complete
    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 100));

      if (consentService.isConsentComplete) {
        _completeInitialization();
        return false; // Stop checking
      }

      return true; // Continue checking
    });
  }

  Future<void> _completeInitialization() async {
    try {
      debugPrint('[SplashController] Consent flow completed, completing initialization');

      // Initialize subscription service
      debugPrint('[SplashController] Initializing subscription service');
      final subscriptionService = await SubscriptionService.init();
      await subscriptionService.getSubscriptionStatus();
      Get.put(subscriptionService);

      // Pre-load first ads if available
      try {
        debugPrint('[SplashController] Initializing ads');
        final adController = Get.find<AdController>();
        adController.initializeAds();
      } catch (e) {
        debugPrint('[SplashController] Error initializing ads: $e');
      }

      isInitialized = true;
      update();
    } catch (e) {
      debugPrint('[SplashController] Error in completing initialization: $e');
      isInitialized = true;
      update();
    }
  }

  Future<void> _initializeServices() async {
    try {
      debugPrint('[SplashController] Starting services initialization');

      // First, handle the consent flow
      debugPrint('[SplashController] Initializing consent service');
      if (!consentService.isConsentDetermined) {
        await consentService.initialize();
      }

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
      debugPrint('[SplashController] Error initializing services: $e');
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
