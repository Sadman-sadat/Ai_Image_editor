import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_ai_editor/presentation/views/result_preview_screen.dart';
import 'package:image_ai_editor/processing_type.dart';
import 'package:image_ai_editor/presentation/controllers/base64_image_conversion_controller.dart';

class ImageProcessingPromptField extends StatelessWidget {
  final Base64ImageConversionController controller;
  final ProcessingType processingType;

  const ImageProcessingPromptField({
    super.key,
    required this.controller,
    required this.processingType,
  });

  void _navigateToResultPreview(TextEditingController promptController) {
    if (promptController.text.isNotEmpty) {
      Get.to(() => ResultPreviewScreen(
        base64Image: controller.processedImageUrl,
        processingType: processingType,
        textPrompt: promptController.text,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController promptController = TextEditingController();

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.05,
        vertical: 8,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: TextFormField(
          controller: promptController,
          decoration: InputDecoration(
            hintText: 'Enter Face Swap generation prompt',
            fillColor: Colors.purple.shade800.withOpacity(0.9),
            filled: true,
            prefixIcon: const Icon(Icons.generating_tokens, color: Colors.grey,),
            suffixIcon: IconButton(
              icon: const Icon(Icons.send, color: Colors.grey),
              onPressed: () => _navigateToResultPreview(promptController),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
          onFieldSubmitted: (_) => _navigateToResultPreview(promptController),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_ai_editor/presentation/controllers/base64_image_conversion_controller.dart';
// import 'package:image_ai_editor/presentation/views/result_preview_screen.dart';
// import 'package:image_ai_editor/processing_type.dart';
//
// class HeadshotGenerationPromptWidget extends StatefulWidget {
//   final Base64ImageConversionController controller;
//   final ProcessingType processingType;
//
//   const HeadshotGenerationPromptWidget({
//     super.key,
//     required this.controller,
//     required this.processingType,
//   });
//
//   @override
//   State<HeadshotGenerationPromptWidget> createState() => _HeadshotGenerationPromptWidgetState();
// }
//
// class _HeadshotGenerationPromptWidgetState extends State<HeadshotGenerationPromptWidget> {
//   final TextEditingController _promptController = TextEditingController();
//
//   @override
//   void dispose() {
//     _promptController.dispose();
//     super.dispose();
//   }
//
//   void _navigateToResultPreview() {
//     if (widget.controller.processedImageUrl.isNotEmpty && _promptController.text.isNotEmpty) {
//       Get.to(() => ResultPreviewScreen(
//         //base64Image: widget.controller.base64ImageString,
//         base64Image: widget.controller.processedImageUrl,
//         //base64Image: 'data:image/jpeg;base64,${widget.controller.base64ImageString}',
//         processingType: widget.processingType,
//         textPrompt: _promptController.text,
//       ));
//     } else {
//       // Show error if image or prompt is missing
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//               widget.controller.processedImageUrl.isEmpty
//                   ? 'Please select an image first'
//                   : 'Please enter a prompt'
//           ),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//       top: 0,
//       left: 0,
//       right: 0,
//       child: Padding(
//         padding: EdgeInsets.symmetric(
//           horizontal: MediaQuery.of(context).size.width * 0.05,
//           vertical: 8,
//         ),
//         child: ConstrainedBox(
//           constraints: const BoxConstraints(maxWidth: 600),
//           child: TextFormField(
//             controller: _promptController,
//             decoration: InputDecoration(
//               hintText: 'Enter Face Swap generation prompt',
//               fillColor: Colors.purple.shade800.withOpacity(0.9),
//               filled: true,
//               suffixIcon: IconButton(
//                 icon: const Icon(Icons.send, color: Colors.grey,),
//                 onPressed: _navigateToResultPreview,
//               ),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8),
//                 borderSide: BorderSide.none,
//               ),
//             ),
//             onFieldSubmitted: (_) => _navigateToResultPreview(),
//           ),
//         ),
//       ),
//     );
//   }
// }