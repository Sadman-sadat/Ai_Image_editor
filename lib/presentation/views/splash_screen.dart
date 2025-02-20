import 'package:appear_ai_image_editor/presentation/controllers/splash_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:appear_ai_image_editor/presentation/utility/app_colors.dart';
import 'package:appear_ai_image_editor/presentation/views/main_bottom_nav_bar_screen.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  final SplashController controller = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<SplashController>(
        builder: (ctrl) => Stack(
          children: [
            // Base image (always visible)
            Positioned.fill(
              child: Image.asset(
                ctrl.imageAssets[ctrl.currentImageIndex],
                fit: BoxFit.cover,
              ),
            ),

            // Animated next image
            Positioned.fill(
              child: FadeTransition(
                opacity: ctrl.animation,
                child: Image.asset(
                  ctrl.imageAssets[ctrl.nextImageIndex],
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Gradient overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.5),
                    ],
                  ),
                ),
              ),
            ),

            // Content
            SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Appear\n',
                              style: TextStyle(
                                fontSize: 52,
                                fontWeight: FontWeight.bold,
                                foreground: Paint()
                                  ..shader = const LinearGradient(
                                    colors: [
                                      Color(0xFF6D0AD4),
                                      Color(0xFFB9DEA8),
                                    ],
                                  ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                              ),
                            ),
                            const TextSpan(
                              text: 'AI Image Editor',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ).copyWith(
                          elevation: WidgetStateProperty.all(0),
                        ),
                        onPressed: () {
                          if (controller.isInitialized) {
                            Get.off(() => MainBottomNavBarScreen());
                          }
                        },
                        child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: AppColors.uploadButtonGradient,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              if (!controller.isInitialized)
                                const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                )
                              else
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Get started',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(
                                      Icons.arrow_right,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}