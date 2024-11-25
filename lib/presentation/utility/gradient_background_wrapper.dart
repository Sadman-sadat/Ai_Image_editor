import 'package:flutter/material.dart';

class GradientBackgroundWrapper extends StatelessWidget {
  final Widget child;

  const GradientBackgroundWrapper({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2f0743), Color(0xFF41295a)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: child,
    );
  }
}
