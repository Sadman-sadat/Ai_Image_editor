import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_ai_editor/controller_binder.dart';
import 'package:image_ai_editor/presentation/utility/app_colors.dart';
import 'package:image_ai_editor/presentation/utility/gradient_background_wrapper.dart';
import 'package:image_ai_editor/presentation/views/splash_screen.dart';

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
      title: 'AI Image Editor',
      home: const SplashScreen(),
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
      builder: (context, child) {
        return GradientBackgroundWrapper(child: child!);
      },
    );
  }

  TextTheme buildTextTheme() {
    return const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
          displayLarge: TextStyle(color: Colors.white),
          displayMedium: TextStyle(color: Colors.white),
          displaySmall: TextStyle(color: Colors.white),
          headlineMedium: TextStyle(color: Colors.white),
          headlineSmall: TextStyle(color: Colors.white),
          titleLarge: TextStyle(color: Colors.white),
          titleMedium: TextStyle(color: Colors.white),
          titleSmall: TextStyle(color: Colors.white),
          labelLarge: TextStyle(color: Colors.white),
          bodySmall: TextStyle(color: Colors.white),
          labelSmall: TextStyle(color: Colors.white),
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
