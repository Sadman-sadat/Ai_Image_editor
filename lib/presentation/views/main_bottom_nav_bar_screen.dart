
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_ai_editor/presentation/controllers/main_bottom_nav_bar_controller.dart';
import 'package:image_ai_editor/presentation/utility/app_colors.dart';
import 'package:image_ai_editor/presentation/views/home_screen.dart';
import 'package:image_ai_editor/presentation/views/result_preview_screen.dart';
import 'package:image_ai_editor/presentation/widgets/bottom_sheet_widget.dart';

class MainBottomNavBarScreen extends StatelessWidget {
  MainBottomNavBarScreen({super.key});

  final MainBottomNavBarController _mainBottomNavBarController = Get.put(MainBottomNavBarController());

  final List<Widget> _screens = [
    const HomeScreen(),
    //const ResultPreviewScreen(base64Image: '',),
  ];

  void _onNavBarTapped(int index) {
    if (index == 2) {
      showCustomBottomSheet(Get.context!);
    } else {
      _mainBottomNavBarController.changeIndex(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => _screens[_mainBottomNavBarController.selectedIndex.value]),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavBarButton(Icons.home, 'Home', 0),
            _buildNavBarButton(Icons.image, 'Preview', 1),
            _buildNavBarButton(Icons.arrow_drop_up, 'More', 2),
          ],
        ),
      ),
    );
  }

  Widget _buildNavBarButton(IconData icon, String label, int index) {
    return Obx(() {
      final isSelected = _mainBottomNavBarController.selectedIndex.value == index;
      return OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: isSelected ? AppColors.primaryColor : Colors.white,
          ),
        ),
        onPressed: () => _onNavBarTapped(index),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? AppColors.primaryColor : Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.primaryColor : Colors.white,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      );
    });
  }
}
