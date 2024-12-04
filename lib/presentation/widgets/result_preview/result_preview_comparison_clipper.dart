import 'package:flutter/material.dart';

class ResultPreviewComparisonClipper extends CustomClipper<Rect> {
  final double progress;

  ResultPreviewComparisonClipper(this.progress);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(0, 0, size.width * progress, size.height);
  }

  @override
  bool shouldReclip(ResultPreviewComparisonClipper oldClipper) {
    return oldClipper.progress != progress;
  }
}