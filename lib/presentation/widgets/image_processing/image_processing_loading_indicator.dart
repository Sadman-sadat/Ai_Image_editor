import 'package:appear_ai_image_editor/presentation/controllers/processing_text_controller.dart';
import 'package:appear_ai_image_editor/presentation/utility/processing_steps.dart';
import 'package:appear_ai_image_editor/presentation/widgets/processing_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImageProcessingLoadingIndicator extends StatelessWidget {
  final String text;

  const ImageProcessingLoadingIndicator({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final uploadController = ProcessingTextController(ProcessingSteps.uploadSteps);
    Get.put(uploadController, tag: 'upload');

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(),
        const SizedBox(height: 16),
        // Text(
        //   text,
        //   style: const TextStyle(
        //     color: Colors.grey,
        //     fontSize: 16,
        //   ),
        // ),
        ProcessingTextWidget(
          controller: Get.find<ProcessingTextController>(tag: 'upload'),
        ),
      ],
    );
  }
}
