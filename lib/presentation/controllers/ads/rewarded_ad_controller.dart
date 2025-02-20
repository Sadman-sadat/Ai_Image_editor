import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:appear_ai_image_editor/data/utility/ad_config.dart';
import 'base_ad_controller.dart';

class RewardedAdController extends BaseAdController {
  RewardedAd? rewardedAd;
  DateTime? lastShowTime;
  static const int cacheDurationHours = 1;
  static const int cooldownSeconds = 45;

  Future<void> preloadRewardedAd() async {
    if (!await shouldShowAds()) return;
    if (isPreloading || isLoaded) return;
    isPreloading = true;

    try {
      await RewardedAd.load(
        adUnitId: AdConfig.rewardedAdUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            rewardedAd = ad;
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
                rewardedAd = null;
                loadTime = null;
                update();
                Future.delayed(const Duration(seconds: 2), preloadRewardedAd);
              },
            );
          },
          onAdFailedToLoad: (error) {
            debugPrint('Rewarded ad failed to load: $error');
            isPreloading = false;
            loadTime = null;
            retryLoading();
            update();
          },
        ),
      );
    } catch (e) {
      isPreloading = false;
      debugPrint('Error preloading rewarded ad: $e');
      retryLoading();
    }
  }

  void retryLoading() {
    if (canRetry()) {
      final delay = getRetryDelay();
      incrementRetryAttempt();

      Future.delayed(Duration(seconds: delay), () {
        if (!isLoaded) {
          preloadRewardedAd();
        }
      });
    }
  }

  Future<bool> showAd({Function? onRewarded}) async {
    if (!await shouldShowAds()) return false;
    if (!canShowAd()) return false;

    if (isLoaded && rewardedAd != null) {
      try {
        await rewardedAd!.show(
          onUserEarnedReward: (_, reward) {
            onRewarded?.call();
            debugPrint('User earned reward: ${reward.amount} ${reward.type}');
          },
        );
        lastShowTime = DateTime.now();
        return true;
      } catch (e) {
        debugPrint('Error showing rewarded ad: $e');
        return false;
      }
    } else {
      debugPrint('Rewarded ad not ready yet');
      preloadRewardedAd();
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
    rewardedAd?.dispose();
    rewardedAd = null;
    isLoaded = false;
  }
}
