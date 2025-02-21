import 'package:appear_ai_image_editor/presentation/views/features/interior_design_generation_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:appear_ai_image_editor/controller_binder.dart';
import 'package:appear_ai_image_editor/presentation/utility/app_colors.dart';
//import 'package:appear_ai_image_editor/presentation/utility/gradient_background_wrapper.dart';
import 'package:appear_ai_image_editor/presentation/utility/image_background_wrapper.dart';
import 'package:appear_ai_image_editor/presentation/views/features/avatar_gen_screen.dart';
import 'package:appear_ai_image_editor/presentation/views/features/background_removal_screen.dart';
import 'package:appear_ai_image_editor/presentation/views/features/face_swap_screen.dart';
import 'package:appear_ai_image_editor/presentation/views/features/head_shot_gen_screen.dart';
import 'package:appear_ai_image_editor/presentation/views/features/image_enhancement_screen.dart';
import 'package:appear_ai_image_editor/presentation/views/features/object_removal_screen.dart';
import 'package:appear_ai_image_editor/presentation/views/features/relighting_screen.dart';
import 'package:appear_ai_image_editor/presentation/views/splash_screen.dart';

class AIImageEditor extends StatefulWidget {
  const AIImageEditor({super.key});

  @override
  State<AIImageEditor> createState() => _AIImageEditorState();
}

class _AIImageEditorState extends State<AIImageEditor> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Appear AI Image Editor',
      home: SplashScreen(),
      initialBinding: ControllerBinder(),
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.transparent,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          centerTitle: true
        ),
          textTheme: buildTextTheme(),
        inputDecorationTheme: _inputDecorationTheme(),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            foregroundColor: Colors.white,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.transparent,
            side: const BorderSide(
              width: 1.2,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
          ),
        )
      ),
      getPages: [
        GetPage(name: '/background_removal', page: () => const BackgroundRemovalScreen()),
        GetPage(name: '/face_swap', page: () => const FaceSwapScreen()),
        GetPage(name: '/head_shot_gen', page: () => const HeadShotGenScreen()),
        GetPage(name: '/avatar_gen', page: () => const AvatarGenScreen()),
        GetPage(name: '/interior_design_gen', page: () => const InteriorDesignGenScreen()),
        GetPage(name: '/relighting', page: () => const RelightingScreen()),
        GetPage(name: '/object_removal', page: () => const ObjectRemovalScreen()),
        GetPage(name: '/image_enhancement', page: () => const ImageEnhancementScreen()),
      ],

      // builder: (context, child) {
      //   return GradientBackgroundWrapper(child: child!);
      // },

      builder: (context, child) {
        return ImageBackgroundWrapper(
          //imagePath: 'assets/images/bg.png',  // Replace with your image path
          imagePath: 'assets/images/background.jpg',  // Replace with your image path
          //overlayColor: Colors.black,  // Optional: adds a color overlay
          //overlayOpacity: 0.3,  // Optional: controls overlay opacity
          child: child!,
        );
      },
    );
  }

  TextTheme buildTextTheme() {
    return const TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
          bodyMedium: TextStyle(color: Colors.black),
          displayLarge: TextStyle(color: Colors.black),
          displayMedium: TextStyle(color: Colors.black),
          displaySmall: TextStyle(color: Colors.black),
          headlineMedium: TextStyle(color: Colors.black),
          headlineSmall: TextStyle(color: Colors.black),
          titleLarge: TextStyle(color: Colors.black),
          titleMedium: TextStyle(color: Colors.black),
          titleSmall: TextStyle(color: Colors.black),
          labelLarge: TextStyle(color: Colors.black),
          bodySmall: TextStyle(color: Colors.black),
          labelSmall: TextStyle(color: Colors.black),
        );
  }

  InputDecorationTheme _inputDecorationTheme() => InputDecorationTheme(
    hintStyle: const TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.w400,
    ),
    border: _outlineInputBorder,
    enabledBorder: _outlineInputBorder,
    focusedBorder: _outlineInputBorder,
    errorBorder: _outlineInputBorder.copyWith(
        borderSide: const BorderSide(color: Colors.red)
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  );

  final OutlineInputBorder _outlineInputBorder = OutlineInputBorder(
    borderSide: BorderSide.none,
    borderRadius: BorderRadius.circular(8),
  );
}
