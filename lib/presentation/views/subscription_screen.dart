import 'package:appear_ai_image_editor/presentation/controllers/subscription_controller.dart';
import 'package:appear_ai_image_editor/presentation/widgets/subscription/subscription_card_widget.dart';
import 'package:appear_ai_image_editor/presentation/widgets/subscription/subscription_feature_Item_widget.dart';
import 'package:appear_ai_image_editor/presentation/widgets/subscription/subscription_footer_widget.dart';
import 'package:appear_ai_image_editor/presentation/widgets/subscription/subscription_header_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final contentWidth = screenWidth > 600 ? 400.0 : screenWidth * 0.9;

    return GetBuilder<SubscriptionController>(
      init: SubscriptionController(),
      builder: (controller) {
        final status = controller.getSubscriptionStatus();
        return Scaffold(
          backgroundColor: const Color(0xFF1A1A2E),
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Container(
                  width: contentWidth,
                  padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const HeaderWidget(),

                      const FeatureItem(text: 'Ad-free Experience'),
                      const FeatureItem(text: 'Unlimited Generation'),
                      const FeatureItem(text: 'Higher Image Quality'),
                      const SizedBox(height: 32),

                      if (status != null)
                        Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: controller.statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: controller.statusColor.withOpacity(0.3)),
                          ),
                          child: Text(
                            status,
                            style: TextStyle(
                              color: controller.statusColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                      // For Testing Purpose remove this later
                      // if (controller.errorMessage != null)
                      //   Padding(
                      //     padding: const EdgeInsets.only(bottom: 16),
                      //     child: Text(
                      //       controller.errorMessage!,
                      //       style: const TextStyle(
                      //         color: Colors.red,
                      //         fontSize: 14,
                      //       ),
                      //     ),
                      //   ),

                      SubscriptionCard(
                        title: 'Basic',
                        subtitle: 'No ads, Pro Features, weekly Subscription',
                        price: controller.getPrice('basic'),
                        discount: '30% off',
                        planId: 'basic',
                        controller: controller,
                      ),
                      const SizedBox(height: 16),

                      SubscriptionCard(
                        title: 'Standard',
                        subtitle: 'No ads, Pro Features, Monthly Subscription',
                        price: controller.getPrice('standard'),
                        discount: '50% off',
                        planId: 'standard',
                        controller: controller,
                      ),
                      const SizedBox(height: 16),

                      SubscriptionCard(
                        title: 'Advanced',
                        subtitle: 'No ads, Pro Features, Quarterly Subscription',
                        price: controller.getPrice('advanced'),
                        discount: '70% off',
                        planId: 'advanced',
                        controller: controller,
                      ),
                      const SizedBox(height: 16),

                      SubscriptionCard(
                        title: 'VIP',
                        subtitle: 'No Ads, Pro Features, Permanently unlocked',
                        price: controller.getPrice('vip'),
                        discount: '90% off',
                        planId: 'vip',
                        controller: controller,
                      ),

                      const SizedBox(height: 24),

                      const FooterWidget(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
