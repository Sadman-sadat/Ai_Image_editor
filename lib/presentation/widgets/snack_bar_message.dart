import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showSnackBarMessage({
  String title = '',
  required String message,
  SnackPosition position = SnackPosition.BOTTOM,
  Duration duration = const Duration(seconds: 3),
  Color colorText = Colors.white,
  //Color? backgroundColor, // Optional background color
  //double blur = 28.0, // Optional blur intensity
}) {
  Get.snackbar(
    title.isEmpty ? 'Notice' : title,
    message,
    snackPosition: position,
    duration: duration,
    colorText: colorText,
    //backgroundColor: backgroundColor ?? Colors.transparent, // Use transparent background to keep blur effect
    //barBlur: backgroundColor == null ? blur : 0.0, // Apply blur if no background color is provided
  );
}