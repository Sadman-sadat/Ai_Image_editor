import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_ai_editor/presentation/views/background_removal_screen.dart';
import 'package:image_ai_editor/presentation/views/image_enhancement_screen.dart';
import 'package:image_ai_editor/presentation/views/object_removal_screen.dart';
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
                const SearchFieldWidget(),
                const SizedBox(height: 8),
                Expanded(
                  child: constraints.maxWidth > 600
                      ? GridView.count(
                    crossAxisCount: constraints.maxWidth > 900 ? 3 : 2,
                    padding: const EdgeInsets.all(16),
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.6, // Adjusted for new proportions
                    children: _buildFeatureCards(),
                  )
                      : ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: _buildFeatureCards()
                        .map((card) => Padding(
                      padding:
                      const EdgeInsets.symmetric(vertical: 4),
                      child: card,
                    ))
                        .toList(),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildFeatureCards() {
    return [
      FeatureCardWidget(
        imageUrl: 'https://i.ytimg.com/vi/7Llzzqjnc0Q/hq720.jpg',
        title: 'Background Removal',
        onButtonPressed: () {
          Get.to(() => BackgroundRemovalScreen());
        },
      ),
      FeatureCardWidget(
        imageUrl:
        'https://zenithclipping.com/wp-content/uploads/2024/04/Image-Enhancement-Service-1024x683.jpg',
        title: 'Image Enhancement',
        onButtonPressed: () {
          Get.to(() => ImageEnhancementScreen());
        },
      ),
      FeatureCardWidget(
        imageUrl:
        'https://i.pcmag.com/imagery/articles/00sSbBtLdbrpARnLKnUr21s-5.fit_lim.size_1600x900.v1692217579.png',
        title: 'Object Removal',
        onButtonPressed: () {
          Get.to(() => ObjectRemovalScreen());
        },
      ),
    ];
  }
}
