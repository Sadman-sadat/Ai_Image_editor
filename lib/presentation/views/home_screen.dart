import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_ai_editor/presentation/controllers/home_screen_controller.dart';
import 'package:image_ai_editor/presentation/widgets/feature_card_widget.dart';
import 'package:image_ai_editor/presentation/widgets/search_field_widget.dart';
import 'package:image_ai_editor/presentation/widgets/snack_bar_message.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            color: Colors.white,
            tooltip: 'Settings',
            onPressed: () {
              showSnackBarMessage(
                title: 'Setting',
                message: 'This is for Setting',
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                const SearchFieldWidget(title: 'Search Features'),
                const SizedBox(height: 8),
                Expanded(
                  child: GetX<HomeScreenController>(
                    builder: (controller) => controller.filteredFeatures.isEmpty
                        ? const Center(child: Text('No features found'))
                        : constraints.maxWidth > 600
                        ? GridView.count(
                      crossAxisCount: constraints.maxWidth > 900 ? 3 : 2,
                      padding: const EdgeInsets.all(16),
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.6,
                      children: controller.filteredFeatures
                          .map((feature) => FeatureCardWidget(
                        imageUrl: feature['imageUrl'],
                        title: feature['title'],
                        onButtonPressed: () => controller.navigateToFeature(feature['screen']),
                      ))
                          .toList(),
                    )
                        : ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: controller.filteredFeatures
                          .map((feature) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: FeatureCardWidget(
                          imageUrl: feature['imageUrl'],
                          title: feature['title'],
                          onButtonPressed: () => controller.navigateToFeature(feature['screen']),
                        ),
                      ))
                          .toList(),
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
}
