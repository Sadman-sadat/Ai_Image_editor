import 'package:appear_ai_image_editor/data/services/consent_service.dart';
import 'package:appear_ai_image_editor/data/services/subscription_service.dart';
import 'package:appear_ai_image_editor/presentation/controllers/ads/banner_ad_controller.dart';
import 'package:appear_ai_image_editor/presentation/controllers/ads/interstitial_ad_controller.dart';
import 'package:appear_ai_image_editor/presentation/controllers/ads/rewarded_ad_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdController extends GetxController {
  late BannerAdController bannerController;
  late InterstitialAdController interstitialController;
  late RewardedAdController rewardedController;

  late SubscriptionService _subscriptionService;
  late ConsentService _consentService;
  bool _isInitialized = false;

  @override
  void onInit() async {
    super.onInit();
    _consentService = Get.find<ConsentService>();

    // Wait for consent to be determined before proceeding
    if (!_consentService.isConsentComplete) {
      // Either wait for it to complete or add a listener
      _consentService.addListener(() {
        if (_consentService.isConsentComplete) {
          _proceedWithAdInitialization();
        }
      });
    } else {
      _proceedWithAdInitialization();
    }
  }

  Future<void> _proceedWithAdInitialization() async {
    await _initSubscriptionService();
    if (await _shouldInitializeAds()) {
      initializeControllers();
      initializeAds();
    }
  }

  Future<void> _initSubscriptionService() async {
    _subscriptionService = Get.find<SubscriptionService>();
    _isInitialized = true;
  }

  Future<bool> _shouldInitializeAds() async {
    if (!_isInitialized) {
      await _initSubscriptionService();
    }
    return _subscriptionService.shouldShowAds();
  }

  void initializeControllers() {
    bannerController = Get.find<BannerAdController>();
    interstitialController = Get.find<InterstitialAdController>();
    rewardedController = Get.find<RewardedAdController>();
  }

  Future<void> initializeAds() async {
    if (!await _shouldInitializeAds()) return;

    try {
      bannerController.loadBannerAd();
      interstitialController.preloadInterstitialAd();
      rewardedController.preloadRewardedAd();
    } catch (e) {
      debugPrint('Error initializing ads: $e');
    }
  }

  BannerAd? get bannerAd => bannerController.bannerAd;
  bool get isAdLoaded => bannerController.isLoaded;
  bool get isInterstitialLoaded => interstitialController.isLoaded;
  bool get isRewardedLoaded => rewardedController.isLoaded;

  Future<bool> showInterstitialAd() => interstitialController.showAd();
  Future<bool> showRewardedAd({Function? onRewarded}) =>
      rewardedController.showAd(onRewarded: onRewarded);

  void disableAds() {
    bannerController.dispose();
    interstitialController.dispose();
    rewardedController.dispose();
    update();
  }

  bool get isLoading =>
      interstitialController.isPreloading ||
          rewardedController.isPreloading;

  Future<void> refreshAdState() async {
    if (await _shouldInitializeAds()) {
      initializeAds();
    } else {
      disableAds();
    }
  }

  @override
  void onClose() {
    bannerController.dispose();
    interstitialController.dispose();
    rewardedController.dispose();
    super.onClose();
  }
}
