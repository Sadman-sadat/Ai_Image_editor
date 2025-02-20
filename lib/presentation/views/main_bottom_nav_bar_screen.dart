import 'package:appear_ai_image_editor/presentation/widgets/ads/banner_ad_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:appear_ai_image_editor/presentation/controllers/main_bottom_nav_bar_controller.dart';
import 'package:appear_ai_image_editor/presentation/utility/app_colors.dart';

class MainBottomNavBarScreen extends StatelessWidget {
  const MainBottomNavBarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainBottomNavBarController>(
      init: MainBottomNavBarController(),
      builder: (controller) {
        if (!controller.isInitialized) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          body: controller.screens[controller.selectedIndex],
          bottomNavigationBar: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const BannerAdWidget(),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: const BoxDecoration(
                  color: Colors.deepOrange,
                  borderRadius: BorderRadius.zero,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNavBarItem(Icons.edit_outlined, 0, controller),
                    _buildNavBarItem(Icons.group_outlined, 1, controller),
                    _buildNavBarItem(Icons.auto_fix_high, 2, controller),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNavBarItem(IconData icon, int index, MainBottomNavBarController controller) {
    final isSelected = controller.selectedIndex == index;
    return InkWell(
      onTap: () => controller.changeIndex(index),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white.withOpacity(0.15) : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isSelected ? AppColors.buttonGradient[0] : AppColors.buttonGradient[1],
          size: 28,
        ),
      ),
    );
  }
}
