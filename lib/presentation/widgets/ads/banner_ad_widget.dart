import 'package:appear_ai_image_editor/presentation/controllers/ads/ad_controller.dart';
import 'package:appear_ai_image_editor/presentation/controllers/ads/banner_ad_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdWidget extends StatelessWidget {
  const BannerAdWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get both controllers to ensure proper dependency
    return GetBuilder<AdController>(
      init: AdController(), // Initialize if not already done
      builder: (mainController) {
        return GetBuilder<BannerAdController>(
          init: BannerAdController(), // Initialize if not already done
          builder: (bannerController) {
            // Check both isLoaded and bannerAd
            if (!bannerController.isLoaded || bannerController.bannerAd == null) {
              // Show placeholder and trigger ad load
              bannerController.loadBannerAd();
              return const SizedBox.shrink();
            }

            // Safe to use bannerAd since we've checked it's not null
            return SizedBox(
              height: bannerController.bannerAd!.size.height.toDouble(),
              width: bannerController.bannerAd!.size.width.toDouble(),
              child: AdWidget(ad: bannerController.bannerAd!),
            );
          },
        );
      },
    );
  }
}
