import 'package:appear_ai_image_editor/presentation/controllers/ads/ad_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RewardedAdWidget extends StatelessWidget {
  final Widget child;
  final VoidCallback onSuccess;
  final bool showAdEveryTime;
  final VoidCallback? onAdFailure;
  final Function(dynamic reward)? onRewardEarned;

  const RewardedAdWidget({
    Key? key,
    required this.child,
    required this.onSuccess,
    this.showAdEveryTime = true,
    this.onAdFailure,
    this.onRewardEarned,
  }) : super(key: key);

  Future<void> _handleTap() async {
    try {
      // Get the controller safely
      final adController = Get.find<AdController>();

      // Show ad if needed
      if (showAdEveryTime) {
        final bool adShown = await adController.showRewardedAd(
          onRewarded: () {
            debugPrint('Reward earned from RewardedAdWidget');
            onRewardEarned?.call({'type': 'reward', 'amount': 1}); // Example reward
          },
        );

        if (!adShown && onAdFailure != null) {
          onAdFailure!();
        }
      }

      // Execute the success callback
      onSuccess();

    } catch (e) {
      debugPrint('Error in RewardedAdWidget: $e');
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
