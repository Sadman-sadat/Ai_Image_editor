import 'package:flutter/material.dart';
import 'package:appear_ai_image_editor/presentation/utility/app_colors.dart';

class ResultPreviewActionButtons extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String label;
  final List<Color> gradientColors;
  final double iconSize;
  final double paddingSize;
  final double fontSize;

  const ResultPreviewActionButtons({
    super.key,
    this.onPressed,
    required this.icon,
    required this.label,
    this.gradientColors = AppColors.uploadButtonGradient,
    this.iconSize = 24.0,
    this.paddingSize = 26.0,
    this.fontSize = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
          ).copyWith(
            elevation: WidgetStateProperty.all(0),
          ),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(paddingSize),
              child: Icon(
                icon,
                color: Colors.white,
                size: iconSize,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: fontSize,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}