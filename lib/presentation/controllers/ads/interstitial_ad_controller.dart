import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:appear_ai_image_editor/data/utility/ad_config.dart';
import 'base_ad_controller.dart';

class InterstitialAdController extends BaseAdController {
  InterstitialAd? interstitialAd;
  DateTime? lastShowTime;
  static const int cacheDurationHours = 1;
  static const int cooldownSeconds = 45;

  Future<void> preloadInterstitialAd() async {
    if (!await shouldShowAds()) return;
    if (isPreloading || isLoaded) return;
    isPreloading = true;

    try {
      await InterstitialAd.load(
        adUnitId: AdConfig.interstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            interstitialAd = ad;
            resetRetryAttempt();
            isLoaded = true;
            isPreloading = false;
            loadTime = DateTime.now();

            // Set orientation to portrait and ensure full screen
            ad.setImmersiveMode(true);

            ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdShowedFullScreenContent: (ad) {
                // Force full screen when ad shows
                SystemChrome.setEnabledSystemUIMode(
                  SystemUiMode.immersiveSticky,
                  overlays: [],
                );
              },
              onAdDismissedFullScreenContent: (ad) {
                // Restore system UI when ad is dismissed
                SystemChrome.setEnabledSystemUIMode(
                  SystemUiMode.manual,
                  overlays: SystemUiOverlay.values,
                );
                ad.dispose();
                isLoaded = false;
                interstitialAd = null;
                loadTime = null;
                update();
                Future.delayed(const Duration(seconds: 2), preloadInterstitialAd);
              },
            );
          },
          onAdFailedToLoad: (error) {
            debugPrint('Interstitial ad failed to load: $error');
            isPreloading = false;
            loadTime = null;
            retryLoading();
            update();
          },
        ),
      );
    } catch (e) {
      isPreloading = false;
      debugPrint('Error preloading interstitial ad: $e');
      retryLoading();
    }
  }

  void retryLoading() {
    if (canRetry()) {
      final delay = getRetryDelay();
      incrementRetryAttempt();

      Future.delayed(Duration(seconds: delay), () {
        if (!isLoaded) {
          preloadInterstitialAd();
        }
      });
    }
  }

  Future<bool> showAd() async {
    if (!await shouldShowAds()) return false;
    if (!canShowAd()) return false;

    if (isLoaded && interstitialAd != null) {
      try {
        await interstitialAd!.show();
        lastShowTime = DateTime.now();
        return true;
      } catch (e) {
        debugPrint('Error showing interstitial ad: $e');
        return false;
      }
    } else {
      debugPrint('Interstitial ad not ready yet');
      preloadInterstitialAd();
      return false;
    }
  }

  bool canShowAd() {
    if (lastShowTime == null) return true;
    final timeSinceLastAd = DateTime.now().difference(lastShowTime!).inSeconds;
    return timeSinceLastAd >= cooldownSeconds;
  }

  int getRemainingCooldown() {
    if (lastShowTime == null) return 0;
    final timeSinceLastAd = DateTime.now().difference(lastShowTime!).inSeconds;
    return timeSinceLastAd >= cooldownSeconds ? 0 : cooldownSeconds - timeSinceLastAd;
  }

  @override
  void dispose() {
    super.dispose();
    interstitialAd?.dispose();
    interstitialAd = null;
    isLoaded = false;
  }
}
