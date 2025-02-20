import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:appear_ai_image_editor/data/utility/ad_config.dart';
import 'base_ad_controller.dart';

class BannerAdController extends BaseAdController {
  BannerAd? bannerAd;
  static const int cacheDurationHours = 4;

  Future<void> loadBannerAd() async {
    if (!await shouldShowAds()) return;

    if (bannerAd != null) {
      await bannerAd!.dispose();
    }

    try {
      bannerAd = BannerAd(
        adUnitId: AdConfig.bannerAdUnitId,
        size: AdSize.fullBanner,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (_) {
            resetRetryAttempt();
            isLoaded = true;
            loadTime = DateTime.now();
            update();
          },
          onAdFailedToLoad: (ad, error) {
            debugPrint('Banner ad failed to load: $error');
            ad.dispose();
            bannerAd = null;
            loadTime = null;
            retryLoading();
            update();
          },
          onAdClosed: (ad) {
            ad.dispose();
            bannerAd = null;
            isLoaded = false;
            loadTime = null;
            update();
            loadBannerAd();
          },
        ),
      );

      await bannerAd?.load();
    } catch (e) {
      debugPrint('Error loading banner ad: $e');
      retryLoading();
    }
  }

  void retryLoading() {
    if (canRetry()) {
      final delay = getRetryDelay();
      incrementRetryAttempt();

      Future.delayed(Duration(seconds: delay), () {
        if (bannerAd == null) {
          loadBannerAd();
        }
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    bannerAd?.dispose();
    bannerAd = null;
    isLoaded = false;
  }
}