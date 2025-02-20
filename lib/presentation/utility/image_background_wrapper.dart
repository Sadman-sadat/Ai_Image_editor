import 'package:flutter/material.dart';

class ImageBackgroundWrapper extends StatelessWidget {
  final Widget child;
  final String imagePath;
  final BoxFit fit;
  final Color? overlayColor;
  final double? overlayOpacity;

  const ImageBackgroundWrapper({
    required this.child,
    required this.imagePath,
    this.fit = BoxFit.cover,
    this.overlayColor,
    this.overlayOpacity,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: fit,
        ),
      ),
      child: Stack(
        children: [
          if (overlayColor != null)
            Container(
              color: overlayColor!.withOpacity(overlayOpacity ?? 0.5),
            ),
          child,
        ],
      ),
    );
  }
}