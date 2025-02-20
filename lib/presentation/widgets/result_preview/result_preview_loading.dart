import 'package:appear_ai_image_editor/presentation/controllers/processing_text_controller.dart';
import 'package:appear_ai_image_editor/presentation/widgets/processing_text_widget.dart';
import 'package:appear_ai_image_editor/processing_type.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'dart:ui';
import 'result_preview_scanning_animation_overlay.dart';

class ResultPreviewLoading extends StatelessWidget {
  final bool isLoading;
  final ProcessingType processingType;
  final double generationTime;
  final String? base64Image;

  ResultPreviewLoading({
    Key? key,
    required this.isLoading,
    required this.processingType,
    required this.generationTime,
    this.base64Image,
  }) : super(key: key) {
    final processingController  = ProcessingTextController(processingType.processingSteps);
    Get.put(processingController);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView( // Add ScrollView to handle overflow
      child: ConstrainedBox( // Add constraints
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height - 200, // Adjust height as needed
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  if (base64Image != null) ...[
                    SizedBox(
                      width: 128,
                      height: 128,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Stack(
                          children: [
                            CachedNetworkImage(
                              imageUrl: base64Image!,
                              fit: BoxFit.cover,
                              width: 128,
                              height: 128,
                              placeholder: (context, url) => Container(
                                color: Colors.grey[200],
                              ),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                            ),
                            BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaX: 4.0,
                                sigmaY: 4.0,
                              ),
                              child: Container(
                                width: 128,
                                height: 128,
                                color: Colors.white.withOpacity(0.1),
                              ),
                            ),
                            ScanningAnimationOverlay(),
                          ],
                        ),
                      ),
                    ),
                  ] else ...[
                    const CircularProgressIndicator(),
                  ],
                ],
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ProcessingTextWidget(
                  controller: Get.find<ProcessingTextController>(),
                ),
              ),
              if (generationTime > 0) ...[
                const SizedBox(height: 8),
                Text(
                  'Estimated time: ${generationTime.toStringAsFixed(1)}s',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
