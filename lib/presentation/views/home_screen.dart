//import 'package:appear_ai_image_editor/presentation/widgets/search_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:appear_ai_image_editor/presentation/controllers/home_screen_controller.dart';
import 'package:appear_ai_image_editor/presentation/views/subscription_screen.dart';
import 'package:appear_ai_image_editor/presentation/widgets/feature_card_widget.dart';
import 'package:appear_ai_image_editor/data/services/subscription_service.dart';
import 'package:appear_ai_image_editor/data/services/feature_usage_service.dart';

class HomeScreen extends StatelessWidget {
  final SubscriptionService subscriptionService;
  final FeatureUsageService featureUsageService;

  const HomeScreen({
    super.key,
    required this.subscriptionService,
    required this.featureUsageService,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Explore',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Get.to(() => const SubscriptionScreen());
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 12),
              child: Image.asset(
                'assets/images/PRO.png',
                height: 80,
                width: 80,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                //remove comments this for Search box
                //const SearchFieldWidget(title: 'Search Features'),
                Expanded(
                  child: GetX<HomeScreenController>(
                    builder: (controller) => controller.filteredFeatures.isEmpty
                        ? const Center(child: Text('No features found'))
                        : constraints.maxWidth > 600
                        ? GridView.count(
                      crossAxisCount:
                      constraints.maxWidth > 900 ? 4 : 2,
                      padding: const EdgeInsets.all(16),
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 2.23,
                      children: _buildFeatureCards(
                        controller,
                        controller.filteredFeatures,
                      ),
                    )
                        : ListView(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 10),
                      children: _buildFeatureCards(
                        controller,
                        controller.filteredFeatures,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildFeatureCards(
      HomeScreenController controller,
      List<Map<String, dynamic>> features,
      ) {
    return features
        .map(
          (feature) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: FeatureCardWidget(
          imageAsset: feature['imageAsset'],
          title: feature['title'],
          featureId: feature['screen'],
          onButtonPressed: () => controller.navigateToFeature(feature['screen']),
          subscriptionService: subscriptionService,
          featureUsageService: featureUsageService,
        ),
      ),
    )
        .toList();
  }
}
