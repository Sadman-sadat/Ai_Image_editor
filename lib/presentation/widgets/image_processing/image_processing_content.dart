import 'package:flutter/material.dart';
import 'package:image_ai_editor/presentation/controllers/base64_image_conversion_controller.dart';
import 'package:image_ai_editor/presentation/widgets/image_processing/image_processing_loading_indicator.dart';
import 'package:image_ai_editor/presentation/widgets/image_processing/image_processing_mask_drawing_content.dart';
import 'package:image_ai_editor/processing_type.dart';

class ImageProcessingContent extends StatelessWidget {
  final Base64ImageConversionController controller;
  final ProcessingType processingType;

  const ImageProcessingContent({
    super.key,
    required this.controller,
    required this.processingType,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              controller.processedImageUrl,
              fit: BoxFit.contain,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const ImageProcessingLoadingIndicator(
                  text: 'Loading image...',
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load image',
                      style: TextStyle(color: Colors.red[700]),
                    ),
                  ],
                );
              },
            ),

            // Mask drawing overlay for object removal
            if (processingType == ProcessingType.objectRemoval)
              ImageProcessingMaskDrawingContent(controller: controller),
          ],
        );
      },
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_ai_editor/presentation/controllers/base64_image_conversion_controller.dart';
// import 'package:image_ai_editor/presentation/controllers/mask_drawing_controller.dart';
// import 'package:image_ai_editor/presentation/widgets/image_processing/image_processing_loading_indicator.dart';
// import 'package:image_ai_editor/processing_type.dart';
//
// class ImageProcessingContent extends StatelessWidget {
//   final Base64ImageConversionController controller;
//   final ProcessingType processingType;
//
//   const ImageProcessingContent({
//     super.key,
//     required this.controller,
//     required this.processingType,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<MaskDrawingController>(
//       builder: (maskController) {
//         return LayoutBuilder(
//           builder: (context, constraints) {
//             return Stack(
//               fit: StackFit.expand,
//               children: [
//                 Image.network(
//                   controller.processedImageUrl,
//                   fit: BoxFit.contain,
//                   loadingBuilder: (context, child, loadingProgress) {
//                     if (loadingProgress == null) return child;
//                     return const ImageProcessingLoadingIndicator(
//                       text: 'Loading image...',
//                     );
//                   },
//                   errorBuilder: (context, error, stackTrace) {
//                     return Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Icon(
//                           Icons.error_outline,
//                           color: Colors.red,
//                           size: 60,
//                         ),
//                         const SizedBox(height: 16),
//                         Text(
//                           'Failed to load image',
//                           style: TextStyle(color: Colors.red[700]),
//                         ),
//                       ],
//                     );
//                   },
//                 ),
//
//                 // Mask drawing overlay for object removal
//                 if (processingType == ProcessingType.objectRemoval &&
//                     maskController.isMaskDrawingMode)
//                   GestureDetector(
//                     onPanStart: (details) {
//                       final RenderBox renderBox = context.findRenderObject() as RenderBox;
//                       final imageBox = context.findAncestorRenderObjectOfType<RenderBox>()!;
//
//                       // Get image size and position
//                       final imageProvider = Image.network(controller.processedImageUrl).image;
//                       imageProvider.resolve(ImageConfiguration()).addListener(
//                           ImageStreamListener((ImageInfo info, bool _) {
//                             final imageSize = Size(
//                                 info.image.width.toDouble(),
//                                 info.image.height.toDouble()
//                             );
//
//                             // Calculate image offset within the canvas
//                             final imagePosition = imageBox.localToGlobal(Offset.zero);
//                             final canvasPosition = renderBox.localToGlobal(Offset.zero);
//                             final imageOffset = imagePosition - canvasPosition;
//
//                             maskController.startMaskDrawing(
//                               imageSize: imageSize,
//                               canvasSize: renderBox.size,
//                               imageOffset: imageOffset,
//                             );
//                           })
//                       );
//                     },
//                     onPanUpdate: (details) {
//                       final RenderBox renderBox = context.findRenderObject() as RenderBox;
//                       final localPosition = renderBox.globalToLocal(details.globalPosition);
//
//                       maskController.addDrawPoint(localPosition);
//                     },
//                     child: CustomPaint(
//                       painter: MaskDrawingPainter(
//                         maskController.drawPoints,
//                         maskController.imageSize ?? Size.zero,
//                         maskController.canvasSize ?? Size.zero,
//                       ),
//                       child: Container(
//                         color: Colors.transparent,
//                       ),
//                     ),
//                   ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
// }
//
// class MaskDrawingPainter extends CustomPainter {
//   final List<Offset> points;
//   final Size imageSize;
//   final Size canvasSize;
//
//   MaskDrawingPainter(this.points, this.imageSize, this.canvasSize);
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     if (points.isEmpty) return;
//
//     final paint = Paint()
//       ..color = Colors.white.withOpacity(0.7)
//       ..strokeCap = StrokeCap.round
//       ..strokeWidth = 15.0;
//
//     // Scale the draw points to match the canvas size
//     final scaledPoints = points.map((point) {
//       return Offset(
//         point.dx * (canvasSize.width / imageSize.width),
//         point.dy * (canvasSize.height / imageSize.height),
//       );
//     }).toList();
//
//
//     for (int i = 0; i < scaledPoints.length - 1; i++) {
//       canvas.drawLine(scaledPoints[i], scaledPoints[i + 1], paint);
//     }
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }
//
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:image_ai_editor/presentation/controllers/base64_image_conversion_controller.dart';
// // import 'package:image_ai_editor/presentation/controllers/mask_drawing_controller.dart';
// // import 'package:image_ai_editor/presentation/widgets/image_processing/image_processing_loading_indicator.dart';
// // import 'package:image_ai_editor/processing_type.dart';
// //
// // class ImageProcessingContent extends StatelessWidget {
// //   final Base64ImageConversionController controller;
// //   final ProcessingType processingType;
// //
// //   const ImageProcessingContent({
// //     super.key,
// //     required this.controller,
// //     required this.processingType,
// //   });
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return GetBuilder<MaskDrawingController>(
// //       builder: (maskController) {
// //         return LayoutBuilder(
// //           builder: (context, constraints) {
// //             return Stack(
// //               fit: StackFit.expand,
// //               children: [
// //                 Image.network(
// //                   controller.processedImageUrl,
// //                   fit: BoxFit.contain,
// //                   loadingBuilder: (context, child, loadingProgress) {
// //                     if (loadingProgress == null) return child;
// //                     return const ImageProcessingLoadingIndicator(
// //                       text: 'Loading image...',
// //                     );
// //                   },
// //                   errorBuilder: (context, error, stackTrace) {
// //                     return Column(
// //                       mainAxisAlignment: MainAxisAlignment.center,
// //                       children: [
// //                         const Icon(
// //                           Icons.error_outline,
// //                           color: Colors.red,
// //                           size: 60,
// //                         ),
// //                         const SizedBox(height: 16),
// //                         Text(
// //                           'Failed to load image',
// //                           style: TextStyle(color: Colors.red[700]),
// //                         ),
// //                       ],
// //                     );
// //                   },
// //                 ),
// //
// //                 // Mask drawing overlay for object removal
// //                 if (processingType == ProcessingType.objectRemoval &&
// //                     maskController.isMaskDrawingMode)
// //                   GestureDetector(
// //                     onPanStart: (details) {
// //                       final RenderBox renderBox = context.findRenderObject() as RenderBox;
// //                       final imageBox = context.findAncestorRenderObjectOfType<RenderBox>()!;
// //
// //                       // Get image size and position
// //                       final imageProvider = Image.network(controller.processedImageUrl).image;
// //                       imageProvider.resolve(ImageConfiguration()).addListener(
// //                           ImageStreamListener((ImageInfo info, bool _) {
// //                             final imageSize = Size(
// //                                 info.image.width.toDouble(),
// //                                 info.image.height.toDouble()
// //                             );
// //
// //                             // Calculate image offset within the canvas
// //                             final imagePosition = imageBox.localToGlobal(Offset.zero);
// //                             final canvasPosition = renderBox.localToGlobal(Offset.zero);
// //                             final imageOffset = imagePosition - canvasPosition;
// //
// //                             maskController.startMaskDrawing(
// //                               imageSize: imageSize,
// //                               canvasSize: renderBox.size,
// //                               imageOffset: imageOffset,
// //                             );
// //                           })
// //                       );
// //                     },
// //                     onPanUpdate: (details) {
// //                       final RenderBox renderBox = context.findRenderObject() as RenderBox;
// //                       final localPosition = renderBox.globalToLocal(details.globalPosition);
// //
// //                       maskController.addDrawPoint(localPosition);
// //                     },
// //                     child: CustomPaint(
// //                       painter: MaskDrawingPainter(
// //                         maskController.drawPoints,
// //                         maskController.imageSize ?? Size.zero,
// //                         maskController.canvasSize ?? Size.zero,
// //                       ),
// //                       child: Container(
// //                         color: Colors.transparent,
// //                       ),
// //                     ),
// //                   ),
// //               ],
// //             );
// //           },
// //         );
// //       },
// //     );
// //   }
// // }
// //
// // class MaskDrawingPainter extends CustomPainter {
// //   final List<Offset> points;
// //   final Size imageSize;
// //   final Size canvasSize;
// //
// //   MaskDrawingPainter(this.points, this.imageSize, this.canvasSize);
// //
// //   @override
// //   void paint(Canvas canvas, Size size) {
// //     if (points.isEmpty) return;
// //
// //     final paint = Paint()
// //       ..color = Colors.white.withOpacity(0.7)
// //       ..strokeCap = StrokeCap.round
// //       ..strokeWidth = 15.0;
// //
// //     // Scale the draw points to match the canvas size
// //     final scaledPoints = points.map((point) {
// //       return Offset(
// //         point.dx * (canvasSize.width / imageSize.width),
// //         point.dy * (canvasSize.height / imageSize.height),
// //       );
// //     }).toList();
// //
// //     for (int i = 0; i < scaledPoints.length - 1; i++) {
// //       canvas.drawLine(scaledPoints[i], scaledPoints[i + 1], paint);
// //     }
// //   }
// //
// //   @override
// //   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// // }
// //
// // // import 'package:flutter/material.dart';
// // // import 'package:get/get.dart';
// // // import 'package:image_ai_editor/presentation/controllers/base64_image_conversion_controller.dart';
// // // import 'package:image_ai_editor/presentation/controllers/mask_drawing_controller.dart';
// // // import 'package:image_ai_editor/presentation/widgets/image_processing/image_processing_loading_indicator.dart';
// // // import 'package:image_ai_editor/processing_type.dart';
// // //
// // // class ImageProcessingContent extends StatelessWidget {
// // //   final Base64ImageConversionController controller;
// // //   final ProcessingType processingType;
// // //
// // //   const ImageProcessingContent({
// // //     super.key,
// // //     required this.controller,
// // //     required this.processingType,
// // //   });
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return GetBuilder<MaskDrawingController>(
// // //       builder: (maskController) {
// // //         return Stack(
// // //           children: [
// // //             Image.network(
// // //               controller.processedImageUrl,
// // //               fit: BoxFit.contain,
// // //               width: MediaQuery.of(context).size.width * 0.9,
// // //               height: MediaQuery.of(context).size.height * 0.6,
// // //               loadingBuilder: (context, child, loadingProgress) {
// // //                 if (loadingProgress == null) return child;
// // //                 return const ImageProcessingLoadingIndicator(
// // //                   text: 'Loading image...',
// // //                 );
// // //               },
// // //               errorBuilder: (context, error, stackTrace) {
// // //                 return Column(
// // //                   mainAxisAlignment: MainAxisAlignment.center,
// // //                   children: [
// // //                     const Icon(
// // //                       Icons.error_outline,
// // //                       color: Colors.red,
// // //                       size: 60,
// // //                     ),
// // //                     const SizedBox(height: 16),
// // //                     Text(
// // //                       'Failed to load image',
// // //                       style: TextStyle(color: Colors.red[700]),
// // //                     ),
// // //                   ],
// // //                 );
// // //               },
// // //             ),
// // //
// // //             // Mask drawing overlay for object removal
// // //             if (processingType == ProcessingType.objectRemoval &&
// // //                 maskController.isMaskDrawingMode)
// // //               GestureDetector(
// // //                 onPanUpdate: (details) {
// // //                   final RenderBox renderBox = context.findRenderObject() as RenderBox;
// // //                   final localPosition = renderBox.globalToLocal(details.globalPosition);
// // //                   maskController.addDrawPoint(localPosition);
// // //                 },
// // //                 child: CustomPaint(
// // //                   painter: MaskDrawingPainter(maskController.drawPoints),
// // //                   child: Container(
// // //                     width: MediaQuery.of(context).size.width * 0.9,
// // //                     height: MediaQuery.of(context).size.height * 0.6,
// // //                     color: Colors.transparent,
// // //                   ),
// // //                 ),
// // //               ),
// // //           ],
// // //         );
// // //       },
// // //     );
// // //   }
// // // }
// // //
// // // class MaskDrawingPainter extends CustomPainter {
// // //   final List<Offset> points;
// // //
// // //   MaskDrawingPainter(this.points);
// // //
// // //   @override
// // //   void paint(Canvas canvas, Size size) {
// // //     if (points.isEmpty) return;
// // //
// // //     final paint = Paint()
// // //       ..color = Colors.white.withOpacity(0.5)
// // //       ..strokeCap = StrokeCap.round
// // //       ..strokeWidth = 10.0;
// // //
// // //     for (int i = 0; i < points.length - 1; i++) {
// // //       canvas.drawLine(points[i], points[i + 1], paint);
// // //     }
// // //   }
// // //
// // //   @override
// // //   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// // // }
// // //
// // // // import 'package:flutter/material.dart';
// // // // import 'package:image_ai_editor/presentation/controllers/base64_image_conversion_controller.dart';
// // // // import 'package:image_ai_editor/presentation/widgets/image_processing/image_processing_loading_indicator.dart';
// // // //
// // // // class ImageProcessingContent extends StatelessWidget {
// // // //   final Base64ImageConversionController controller;
// // // //
// // // //   const ImageProcessingContent({
// // // //     super.key,
// // // //     required this.controller,
// // // //   });
// // // //
// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Image.network(
// // // //       controller.processedImageUrl,
// // // //       fit: BoxFit.contain,
// // // //       width: MediaQuery.of(context).size.width * 0.9,
// // // //       height: MediaQuery.of(context).size.height * 0.6,
// // // //       loadingBuilder: (context, child, loadingProgress) {
// // // //         if (loadingProgress == null) return child;
// // // //         return const ImageProcessingLoadingIndicator(
// // // //           text: 'Loading image...',
// // // //         );
// // // //       },
// // // //       errorBuilder: (context, error, stackTrace) {
// // // //         return Column(
// // // //           mainAxisAlignment: MainAxisAlignment.center,
// // // //           children: [
// // // //             const Icon(
// // // //               Icons.error_outline,
// // // //               color: Colors.red,
// // // //               size: 60,
// // // //             ),
// // // //             const SizedBox(height: 16),
// // // //             Text(
// // // //               'Failed to load image',
// // // //               style: TextStyle(color: Colors.red[700]),
// // // //             ),
// // // //           ],
// // // //         );
// // // //       },
// // // //     );
// // // //   }
// // // // }
