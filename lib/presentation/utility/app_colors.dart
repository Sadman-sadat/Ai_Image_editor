import 'package:flutter/material.dart';

class AppColors{
  static const Color primaryColor = Color(0xFFFF9800);

  // Gradient Colors for Card Background
  static const List<Color> cardGradient = [
    Color(0xFF6D0AD4), // Purple start
    Color(0xFF1A0034), // Blue end
  ];
  // Gradient Colors for Card Background
  static const List<Color> cardSetting = [
    Color(0xFF0A1F44), // Deep Navy Blue
    Color(0xFF001233), // Very Dark Blue
    Color(0xFF0C036E), // Deep Royal Blue
    Color(0xFF04021A), // Very Dark Blue
    Color(0xFF05022D), // Dark Midnight Blue
    Color(0xFF0B0157), // Intense Deep Blue
  ];
  // Gradient Colors for Card Background
  static const List<Color> uploadButtonGradient = [
    Color(0xFFCF38FF), // Purple start
    Color(0xFF8057FC), // Blue end
  ];

  // Button Gradients
  static const List<Color> buttonGradient = [
    Color(0xFFECFEE5), // Light gradient start
    Color(0xFFF0DBFE), // Light gradient end
  ];

  // Button Press State Gradients
  static const List<Color> buttonPressedGradient = [
    Color(0xFFC894EA), // Darker when pressed
    Color(0xFFB9DEA8), // Darker when pressed
  ];
}