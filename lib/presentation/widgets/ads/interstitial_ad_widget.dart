import 'package:appear_ai_image_editor/presentation/controllers/ads/ad_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InterstitialAdWidget extends StatelessWidget {
  final Widget child;
  final VoidCallback onSuccess;
  final bool showAdEveryTime;
  final VoidCallback? onAdFailure;

  const InterstitialAdWidget({
    Key? key,
    required this.child,
    required this.onSuccess,
    this.showAdEveryTime = true,
    this.onAdFailure,
  }) : super(key: key);

  Future<void> _handleTap() async {
    try {
      // Get the controller safely
      final adController = Get.find<AdController>();

      // Execute the callback
      onSuccess();

      // Show ad if needed
      if (showAdEveryTime) {
        final bool adShown = await adController.showInterstitialAd();
        if (!adShown && onAdFailure != null) {
          onAdFailure!();
        }
      }
    } catch (e) {
      debugPrint('Error in InterstitialAdWidget: $e');
      onAdFailure?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: child,
    );
  }
}
