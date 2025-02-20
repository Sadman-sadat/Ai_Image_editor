import 'package:appear_ai_image_editor/presentation/controllers/processing_text_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProcessingTextWidget extends StatelessWidget {
  final ProcessingTextController controller;
  final bool showFirstStepOnly;

  const ProcessingTextWidget({
    Key? key,
    required this.controller,
    this.showFirstStepOnly = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProcessingTextController>(
      init: controller,
      builder: (controller) {
        return Text(
          showFirstStepOnly
              ? '${controller.steps[0]}${controller.dots}'
              : '${controller.steps[controller.currentStep]}${controller.dots}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        );
      },
    );
  }
}