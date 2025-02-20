import 'package:appear_ai_image_editor/data/models/subscription_status_model.dart';
import 'package:appear_ai_image_editor/presentation/utility/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:appear_ai_image_editor/data/services/subscription_service.dart';
import 'package:appear_ai_image_editor/presentation/views/subscription_screen.dart';
import 'package:appear_ai_image_editor/data/services/feature_usage_service.dart';

class FeatureCardWidget extends StatelessWidget {
  final String imageAsset;
  final String title;
  final VoidCallback onButtonPressed;
  final String featureId;
  final SubscriptionService subscriptionService;
  final FeatureUsageService featureUsageService;

  const FeatureCardWidget({
    super.key,
    required this.imageAsset,
    required this.title,
    required this.onButtonPressed,
    required this.featureId,
    required this.subscriptionService,
    required this.featureUsageService,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 300;

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 3,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.22,
              width: double.infinity,
              child: Stack(
                children: [
                  Image.asset(
                    imageAsset,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.fill,
                  ),
                  if (featureUsageService.isProFeature(featureId))
                    const Banner(
                      message: 'Pro',
                      location: BannerLocation.topStart,
                      color: Colors.deepOrange,
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: isSmallScreen
                          ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _buildCardContent(),
                      )
                          : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: _buildCardContent(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildCardContent() {
    return [
      Flexible(
        child: Text(
          title.toUpperCase(),
          maxLines: 1,
          style: const TextStyle(
            overflow: TextOverflow.ellipsis,
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      const SizedBox(width: 8),
      _buildActionButton(),
    ];
  }

  Widget _buildActionButton() {
    return FutureBuilder<SubscriptionStatusModel>(
      future: subscriptionService.getSubscriptionStatus(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }

        final isSubscribed = snapshot.data!.isActive;
        final hasUsedFeature = featureUsageService.hasUsedFeature(featureId);
        final isProFeature = featureUsageService.isProFeature(featureId);

        if (isProFeature && !isSubscribed && hasUsedFeature) {
          return _TryOutButton(
            onPressed: () => Get.to(() => const SubscriptionScreen()),
            buttonText: 'PRO',
          );
        }

        return _TryOutButton(
          onPressed: () async {
            if (isProFeature && !isSubscribed) {
              await featureUsageService.markFeatureAsUsed(featureId);
            }
            onButtonPressed();
          },
          buttonText: 'TRY OUT',
        );
      },
    );
  }
}

class _TryOutButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;

  const _TryOutButton({
    required this.onPressed,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: AppColors.buttonGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          buttonText,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
