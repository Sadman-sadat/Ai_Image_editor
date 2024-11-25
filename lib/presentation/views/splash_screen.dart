import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_ai_editor/presentation/views/main_bottom_nav_bar_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            const Positioned.fill(
              child: Center(
                child: Text(
                  'Welcome to AI Image Editor!',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
            ),
            Positioned(
              bottom: 40,
              left: 20,
              right: 20,
              child: IconButton(
                iconSize: 48,
                icon: const Icon(Icons.arrow_right,),
                color: Colors.white,
                onPressed: () {
                  Get.off(() => MainBottomNavBarScreen());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
