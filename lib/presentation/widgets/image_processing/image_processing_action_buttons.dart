import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_ai_editor/presentation/controllers/base64_image_conversion_controller.dart';
import 'package:image_ai_editor/presentation/controllers/mask_drawing_controller.dart';
import 'package:image_ai_editor/presentation/views/result_preview_screen.dart';
import 'package:image_ai_editor/presentation/widgets/image_processing/image_processing_prompt_widget.dart';
import 'package:image_ai_editor/presentation/widgets/snack_bar_message.dart';
import 'package:image_ai_editor/processing_type.dart';
import 'package:image_picker/image_picker.dart';

class ImageProcessingActionButtons extends StatelessWidget {
  final Base64ImageConversionController controller;
  final ProcessingType processingType;

  const ImageProcessingActionButtons({
    super.key,
    required this.controller,
    required this.processingType,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MaskDrawingController>(
      init: MaskDrawingController(processingType: processingType),
      builder: (maskController) {
        return GetBuilder<Base64ImageConversionController>(
          builder: (controller) {
            return controller.selectedImage != null
                ? _buildButtons(context, maskController)
                : _buildPickButtons();
          },
        );
      },
    );
  }

  Widget _buildButtons(BuildContext context, MaskDrawingController maskController) {
    if (processingType == ProcessingType.objectRemoval) {
      // Existing object removal logic remains the same
      if (maskController.isMaskDrawingMode) {
        return _buildObjectRemovalButtons(context, maskController);
      } else if (maskController.base64MaskImage.isNotEmpty) {
        return _buildUploadButton(maskController);
      } else {
        return _buildObjectRemovalUploadButton(maskController);
      }
    } else if (processingType == ProcessingType.headShotGen) {
      // Use the new HeadshotGenPromptField widget
      return ImageProcessingPromptField(
        controller: controller,
        processingType: processingType,
      );
    }
    // For other processing types, just show upload button
    return _buildUploadButton(maskController);
  }

  Widget _buildObjectRemovalButtons(BuildContext context, MaskDrawingController maskController) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton.icon(
            onPressed: () => maskController.clearDrawPoints(),
            icon: const Icon(Icons.clear),
            label: const Text('Clear Mask'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              final maskBase64 = await maskController.generateMaskImage();

              if (maskBase64 == null) {
                showSnackBarMessage(
                  title: 'Error',
                  message: 'Failed to generate mask',
                );
                return;
              }

              final success = await maskController.uploadMaskImage(
                  controller.base64ImageString
              );

              if (success) {
                maskController.update();
              }
            },
            icon: const Icon(Icons.check),
            label: const Text('Confirm Mask'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          ),
        ],
      ),
    );
  }

  Widget _buildObjectRemovalUploadButton(MaskDrawingController maskController) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Center(
        child: ElevatedButton.icon(
          onPressed: () {
            maskController.startMaskDrawing(
              imageSize: Size(0, 0), // Placeholder, will be updated in content widget
              canvasSize: Size(0, 0), // Placeholder, will be updated in content widget
            );
          },
          icon: const Icon(Icons.draw),
          label: const Text('Draw Mask'),
        ),
      ),
    );
  }

  Widget _buildPickButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildPickButton(
            icon: Icons.photo_library,
            label: 'Gallery',
            source: ImageSource.gallery,
          ),
          _buildPickButton(
            icon: Icons.camera_alt,
            label: 'Camera',
            source: ImageSource.camera,
          ),
        ],
      ),
    );
  }

  Widget _buildPickButton({
    required IconData icon,
    required String label,
    required ImageSource source,
  }) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => controller.pickImage(source),
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(20),
          ),
          child: Icon(icon),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildUploadButton(MaskDrawingController maskController) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Center(
        child: SizedBox(
          height: 50,
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              Get.to(() => ResultPreviewScreen(
                base64Image: controller.processedImageUrl,
                processingType: processingType,
                maskImage: maskController.processedMaskUrl ?? '',
                comparisonMode: true,
              ));
            },
            icon: const Icon(Icons.upload),
            label: Text(processingType.title),
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_ai_editor/presentation/controllers/base64_image_conversion_controller.dart';
// import 'package:image_ai_editor/presentation/controllers/mask_drawing_controller.dart';
// import 'package:image_ai_editor/presentation/views/result_preview_screen.dart';
// import 'package:image_ai_editor/presentation/widgets/snack_bar_message.dart';
// import 'package:image_ai_editor/processing_type.dart';
// import 'package:image_picker/image_picker.dart';
//
// class ImageProcessingActionButtons extends StatelessWidget {
//   final Base64ImageConversionController controller;
//   final ProcessingType processingType;
//
//   const ImageProcessingActionButtons({
//     super.key,
//     required this.controller,
//     required this.processingType,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<MaskDrawingController>(
//       init: MaskDrawingController(processingType: processingType),
//       builder: (maskController) {
//         return GetBuilder<Base64ImageConversionController>(
//           builder: (controller) {
//             return controller.selectedImage != null
//                 ? _buildButtons(context, maskController)
//                 : _buildPickButtons();
//           },
//         );
//       },
//     );
//   }
//
//   Widget _buildButtons(BuildContext context, MaskDrawingController maskController) {
//     if (processingType == ProcessingType.objectRemoval) {
//       // If mask drawing mode is active, show mask drawing buttons
//       if (maskController.isMaskDrawingMode) {
//         return _buildObjectRemovalButtons(context, maskController);
//       }
//       // If mask is confirmed, show upload button
//       else if (maskController.isMaskConfirmed) {
//         return _buildUploadButton(maskController);
//       }
//       // Default: show draw mask button
//       else {
//         return _buildObjectRemovalUploadButton(maskController);
//       }
//     }
//     // For other processing types, just show upload button
//     return _buildUploadButton(maskController);
//   }
//
//   Widget _buildObjectRemovalButtons(BuildContext context, MaskDrawingController maskController) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           ElevatedButton.icon(
//             onPressed: () => maskController.clearDrawPoints(),
//             icon: const Icon(Icons.clear),
//             label: const Text('Clear Mask'),
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//           ),
//           ElevatedButton.icon(
//             onPressed: () async {
//               // Remove the parameter from generateMaskImage
//               final maskBase64 = await maskController.generateMaskImage();
//
//               if (maskBase64 == null) {
//                 showSnackBarMessage(
//                   title: 'Error',
//                   message: 'Failed to generate mask',
//                 );
//                 return;
//               }
//
//               final success = await maskController.uploadMaskImage(
//                   controller.base64ImageString
//               );
//
//               if (success) {
//                 maskController.update();
//               }
//             },
//             icon: const Icon(Icons.check),
//             label: const Text('Confirm Mask'),
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildObjectRemovalUploadButton(MaskDrawingController maskController) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
//       child: Center(
//         child: ElevatedButton.icon(
//           onPressed: () {
//             maskController.startMaskDrawing();
//           },
//           icon: const Icon(Icons.draw),
//           label: const Text('Draw Mask'),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPickButtons() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           _buildPickButton(
//             icon: Icons.photo_library,
//             label: 'Gallery',
//             source: ImageSource.gallery,
//           ),
//           _buildPickButton(
//             icon: Icons.camera_alt,
//             label: 'Camera',
//             source: ImageSource.camera,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildPickButton({
//     required IconData icon,
//     required String label,
//     required ImageSource source,
//   }) {
//     return Column(
//       children: [
//         ElevatedButton(
//           onPressed: () => controller.pickImage(source),
//           style: ElevatedButton.styleFrom(
//             shape: const CircleBorder(),
//             padding: const EdgeInsets.all(20),
//           ),
//           child: Icon(icon),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           label,
//           style: const TextStyle(fontSize: 16),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildUploadButton(MaskDrawingController maskController) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
//       child: Center(
//         child: SizedBox(
//           height: 50,
//           width: double.infinity,
//           child: ElevatedButton.icon(
//             onPressed: () {
//               Get.to(() => ResultPreviewScreen(
//                 base64Image: controller.processedImageUrl,
//                 processingType: processingType,
//                 maskImage: maskController.processedMaskUrl,
//               ));
//             },
//             icon: const Icon(Icons.upload),
//             label: Text(processingType.title),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:image_ai_editor/presentation/controllers/base64_image_conversion_controller.dart';
// // import 'package:image_ai_editor/presentation/controllers/mask_drawing_controller.dart';
// // import 'package:image_ai_editor/presentation/views/result_preview_screen.dart';
// // import 'package:image_ai_editor/presentation/widgets/snack_bar_message.dart';
// // import 'package:image_ai_editor/processing_type.dart';
// // import 'package:image_picker/image_picker.dart';
// //
// // class ImageProcessingActionButtons extends StatelessWidget {
// //   final Base64ImageConversionController controller;
// //   final ProcessingType processingType;
// //
// //   const ImageProcessingActionButtons({
// //     super.key,
// //     required this.controller,
// //     required this.processingType,
// //   });
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return GetBuilder<MaskDrawingController>(
// //       init: MaskDrawingController(processingType: processingType),
// //       builder: (maskController) {
// //         return GetBuilder<Base64ImageConversionController>(
// //           builder: (controller) {
// //             return controller.selectedImage != null
// //                 ? _buildButtons(context, maskController)
// //                 : _buildPickButtons();
// //           },
// //         );
// //       },
// //     );
// //   }
// //
// //   Widget _buildButtons(BuildContext context, MaskDrawingController maskController) {
// //     if (processingType == ProcessingType.objectRemoval) {
// //       // If mask drawing mode is active, show mask drawing buttons
// //       if (maskController.isMaskDrawingMode) {
// //         return _buildObjectRemovalButtons(context, maskController);
// //       }
// //       // If mask is confirmed, show upload button
// //       else if (maskController.isMaskConfirmed) {
// //         return _buildUploadButton(maskController);
// //       }
// //       // Default: show draw mask button
// //       else {
// //         return _buildObjectRemovalUploadButton(maskController);
// //       }
// //     }
// //     // For other processing types, just show upload button
// //     return _buildUploadButton(maskController);
// //   }
// //
// //   Widget _buildObjectRemovalButtons(BuildContext context, MaskDrawingController maskController) {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
// //       child: Row(
// //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //         children: [
// //           ElevatedButton.icon(
// //             onPressed: () => maskController.clearDrawPoints(),
// //             icon: const Icon(Icons.clear),
// //             label: const Text('Clear Mask'),
// //             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
// //           ),
// //           ElevatedButton.icon(
// //             onPressed: () async {
// //               final RenderBox renderBox = context.findRenderObject() as RenderBox;
// //               final size = renderBox.size;
// //
// //               // Pass the original base64 image to generate mask
// //               final maskBase64 = await maskController.generateMaskImage(
// //                   controller.base64ImageString // Assume you have this method in your Base64ImageConversionController
// //               );
// //
// //               if (maskBase64 == null) {
// //                 showSnackBarMessage(
// //                   title: 'Error',
// //                   message: 'Failed to generate mask',
// //                 );
// //                 return;
// //               }
// //
// //               final success = await maskController.uploadMaskImage(
// //                   controller.base64ImageString // Pass original image base64
// //               );
// //
// //               if (success) {
// //                 maskController.update();
// //               }
// //             },
// //             icon: const Icon(Icons.check),
// //             label: const Text('Confirm Mask'),
// //             style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildObjectRemovalUploadButton(MaskDrawingController maskController) {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
// //       child: Center(
// //         child: ElevatedButton.icon(
// //           onPressed: () {
// //             maskController.startMaskDrawing();
// //           },
// //           icon: const Icon(Icons.draw),
// //           label: const Text('Draw Mask'),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildPickButtons() {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
// //       child: Row(
// //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //         children: [
// //           _buildPickButton(
// //             icon: Icons.photo_library,
// //             label: 'Gallery',
// //             source: ImageSource.gallery,
// //           ),
// //           _buildPickButton(
// //             icon: Icons.camera_alt,
// //             label: 'Camera',
// //             source: ImageSource.camera,
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildPickButton({
// //     required IconData icon,
// //     required String label,
// //     required ImageSource source,
// //   }) {
// //     return Column(
// //       children: [
// //         ElevatedButton(
// //           onPressed: () => controller.pickImage(source),
// //           style: ElevatedButton.styleFrom(
// //             shape: const CircleBorder(),
// //             padding: const EdgeInsets.all(20),
// //           ),
// //           child: Icon(icon),
// //         ),
// //         const SizedBox(height: 8),
// //         Text(
// //           label,
// //           style: const TextStyle(fontSize: 16),
// //         ),
// //       ],
// //     );
// //   }
// //
// //   Widget _buildUploadButton(MaskDrawingController maskController) {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
// //       child: Center(
// //         child: SizedBox(
// //           height: 50,
// //           width: double.infinity,
// //           child: ElevatedButton.icon(
// //             onPressed: () {
// //               Get.to(() => ResultPreviewScreen(
// //                 base64Image: controller.processedImageUrl,
// //                 processingType: processingType,
// //                 maskImage: maskController.processedMaskUrl,
// //               ));
// //             },
// //             icon: const Icon(Icons.upload),
// //             label: Text(processingType.title),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// //
// //
// // // import 'package:flutter/material.dart';
// // // import 'package:get/get.dart';
// // // import 'package:image_ai_editor/presentation/controllers/base64_image_conversion_controller.dart';
// // // import 'package:image_ai_editor/presentation/controllers/mask_drawing_controller.dart';
// // // import 'package:image_ai_editor/presentation/views/result_preview_screen.dart';
// // // import 'package:image_ai_editor/processing_type.dart';
// // // import 'package:image_picker/image_picker.dart';
// // //
// // // class ImageProcessingActionButtons extends StatelessWidget {
// // //   final Base64ImageConversionController controller;
// // //   final ProcessingType processingType;
// // //
// // //   const ImageProcessingActionButtons({
// // //     super.key,
// // //     required this.controller,
// // //     required this.processingType,
// // //   });
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return GetBuilder<MaskDrawingController>(
// // //       init: MaskDrawingController(processingType: processingType),
// // //       builder: (maskController) {
// // //         return GetBuilder<Base64ImageConversionController>(
// // //           builder: (controller) {
// // //             return controller.selectedImage != null
// // //                 ? _buildButtons(context, maskController)
// // //                 : _buildPickButtons();
// // //           },
// // //         );
// // //       },
// // //     );
// // //   }
// // //
// // //   // Method to build buttons based on processing type
// // //   Widget _buildButtons(BuildContext context, MaskDrawingController maskController) {
// // //     if (processingType == ProcessingType.objectRemoval) {
// // //       return _buildObjectRemovalButtons(context, maskController);
// // //     }
// // //     return _buildUploadButton();
// // //   }
// // //
// // //   // Build buttons for object removal
// // //   Widget _buildObjectRemovalButtons(BuildContext context, MaskDrawingController maskController) {
// // //     if (maskController.isMaskDrawingMode) {
// // //       return Padding(
// // //         padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
// // //         child: Row(
// // //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// // //           children: [
// // //             ElevatedButton.icon(
// // //               onPressed: () => maskController.clearDrawPoints(),
// // //               icon: const Icon(Icons.clear),
// // //               label: const Text('Clear Mask'),
// // //               style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
// // //             ),
// // //             ElevatedButton.icon(
// // //               onPressed: () async {
// // //                 final RenderBox renderBox = context.findRenderObject() as RenderBox;
// // //                 final size = renderBox.size;
// // //
// // //                 final success = await maskController.processObjectRemoval(
// // //                     controller.base64ImageString,
// // //                     size
// // //                 );
// // //                 if (success) {
// // //                   controller.clearCurrentImage();
// // //                 }
// // //               },
// // //               icon: const Icon(Icons.check),
// // //               label: const Text('Confirm Mask'),
// // //               style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
// // //             ),
// // //           ],
// // //         ),
// // //       );
// // //     }
// // //
// // //     return _buildObjectRemovalUploadButton(maskController);
// // //   }
// // //
// // //   Widget _buildObjectRemovalUploadButton(MaskDrawingController maskController) {
// // //     return Padding(
// // //       padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
// // //       child: Center(
// // //         child: ElevatedButton.icon(
// // //           onPressed: () {
// // //             maskController.startMaskDrawing();
// // //           },
// // //           icon: const Icon(Icons.draw),
// // //           label: const Text('Draw Mask'),
// // //         ),
// // //       ),
// // //     );
// // //   }
// // //
// // //   Widget _buildPickButtons() {
// // //     return Padding(
// // //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
// // //       child: Row(
// // //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// // //         children: [
// // //           _buildPickButton(
// // //             icon: Icons.photo_library,
// // //             label: 'Gallery',
// // //             source: ImageSource.gallery,
// // //           ),
// // //           _buildPickButton(
// // //             icon: Icons.camera_alt,
// // //             label: 'Camera',
// // //             source: ImageSource.camera,
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // //
// // //   Widget _buildPickButton({
// // //     required IconData icon,
// // //     required String label,
// // //     required ImageSource source,
// // //   }) {
// // //     return Column(
// // //       children: [
// // //         ElevatedButton(
// // //           onPressed: () => controller.pickImage(source),
// // //           style: ElevatedButton.styleFrom(
// // //             shape: const CircleBorder(),
// // //             padding: const EdgeInsets.all(20),
// // //           ),
// // //           child: Icon(icon),
// // //         ),
// // //         const SizedBox(height: 8),
// // //         Text(
// // //           label,
// // //           style: const TextStyle(fontSize: 16),
// // //         ),
// // //       ],
// // //     );
// // //   }
// // //
// // //   Widget _buildUploadButton() {
// // //     return Padding(
// // //       padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
// // //       child: Center(
// // //         child: SizedBox(
// // //           height: 50,
// // //           width: double.infinity,
// // //           child: ElevatedButton.icon(
// // //             onPressed: () {
// // //               Get.to(() => ResultPreviewScreen(
// // //                 base64Image: controller.processedImageUrl,
// // //                 processingType: processingType,
// // //               ));
// // //             },
// // //             icon: const Icon(Icons.upload),
// // //             label: Text(processingType.title),
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
// // //
// // //
// // //
// // // // import 'package:flutter/material.dart';
// // // // import 'package:get/get.dart';
// // // // import 'package:image_ai_editor/presentation/controllers/base64_image_conversion_controller.dart';
// // // // import 'package:image_ai_editor/presentation/views/result_preview_screen.dart';
// // // // import 'package:image_ai_editor/processing_type.dart';
// // // // import 'package:image_picker/image_picker.dart';
// // // //
// // // // class ImageProcessingActionButtons extends StatelessWidget {
// // // //   final Base64ImageConversionController controller;
// // // //   final ProcessingType processingType;
// // // //
// // // //   const ImageProcessingActionButtons({
// // // //     super.key,
// // // //     required this.controller,
// // // //     required this.processingType,
// // // //   });
// // // //
// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return GetBuilder<Base64ImageConversionController>(
// // // //       builder: (controller) {
// // // //         return controller.selectedImage != null
// // // //             ? _buildUploadButton()
// // // //             : _buildPickButtons();
// // // //       },
// // // //     );
// // // //   }
// // // //
// // // //   // Method to build the camera and gallery buttons
// // // //   Widget _buildPickButtons() {
// // // //     return Padding(
// // // //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
// // // //       child: Row(
// // // //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// // // //         children: [
// // // //           _buildPickButton(
// // // //             icon: Icons.photo_library,
// // // //             label: 'Gallery',
// // // //             source: ImageSource.gallery,
// // // //           ),
// // // //           _buildPickButton(
// // // //             icon: Icons.camera_alt,
// // // //             label: 'Camera',
// // // //             source: ImageSource.camera,
// // // //           ),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }
// // // //
// // // //   Widget _buildPickButton({
// // // //     required IconData icon,
// // // //     required String label,
// // // //     required ImageSource source,
// // // //   }) {
// // // //     return Column(
// // // //       children: [
// // // //         ElevatedButton(
// // // //           onPressed: () => controller.pickImage(source),
// // // //           style: ElevatedButton.styleFrom(
// // // //             shape: const CircleBorder(),
// // // //             padding: const EdgeInsets.all(20),
// // // //           ),
// // // //           child: Icon(icon),
// // // //         ),
// // // //         const SizedBox(height: 8),
// // // //         Text(
// // // //           label,
// // // //           style: const TextStyle(fontSize: 16),
// // // //         ),
// // // //       ],
// // // //     );
// // // //   }
// // // //
// // // //   // Method to build the Upload button
// // // //   Widget _buildUploadButton() {
// // // //     return Padding(
// // // //       padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
// // // //       child: Center(
// // // //         child: SizedBox(
// // // //           height: 50,
// // // //           width: double.infinity,
// // // //           child: ElevatedButton.icon(
// // // //             onPressed: () {
// // // //               Get.to(() => ResultPreviewScreen(
// // // //                 base64Image: controller.processedImageUrl,
// // // //                 processingType: processingType,
// // // //               ));
// // // //             },
// // // //             icon: const Icon(Icons.upload),
// // // //             label: Text(processingType.title),
// // // //           ),
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // // }
