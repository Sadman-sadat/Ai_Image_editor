import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:appear_ai_image_editor/presentation/controllers/result_preview/result_screen_image_comparison_controller.dart';
import 'package:appear_ai_image_editor/presentation/widgets/result_preview/result_preview_comparison_clipper.dart';
import 'package:appear_ai_image_editor/presentation/widgets/result_preview/result_preview_error.dart';

class ResultPreviewComparisonOverlay extends StatelessWidget {
  final GlobalKey imageKey;
  final String beforeImageUrl;
  final VoidCallback onRetry;

  const ResultPreviewComparisonOverlay({
    super.key,
    required this.imageKey,
    required this.beforeImageUrl,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final RenderBox? imageBox =
        imageKey.currentContext?.findRenderObject() as RenderBox?;
        if (imageBox == null) return const SizedBox.shrink();

        final imageSize = imageBox.size;

        return GetBuilder<ComparisonController>(
          builder: (comparisonController) {
            return comparisonController.isComparisonMode
                ? SizedBox(
              width: imageSize.width,
              height: imageSize.height,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Clipped Before Image
                  ClipRect(
                    clipper: ResultPreviewComparisonClipper(
                        comparisonController.dividerPosition),
                    child: Image.network(
                      beforeImageUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) =>
                          ResultPreviewError(onRetry: onRetry),
                    ),
                  ),

                  // Left-side "Before" text
                  Positioned(
                    left: 10,
                    top: 10,
                    child: _buildComparisonLabel("Before"),
                  ),

                  // Right-side "After" text
                  Positioned(
                    right: 10,
                    top: 10,
                    child: _buildComparisonLabel("After"),
                  ),

                  // Vertical divider line
                  Positioned(
                    left: imageSize.width * comparisonController.dividerPosition - 1.5,
                    top: 0,
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onHorizontalDragUpdate: (details) {
                        final double newPosition =
                            comparisonController.dividerPosition +
                                details.delta.dx / imageSize.width;
                        comparisonController.updateDividerPosition(newPosition);
                      },
                      child: Container(
                        width: 3,
                        height: imageSize.height,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  // Handle with icon
                  Positioned(
                    left: imageSize.width * comparisonController.dividerPosition - 15,
                    top: imageSize.height * 0.5 - 15,
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onHorizontalDragUpdate: (details) {
                        final double newPosition =
                            comparisonController.dividerPosition +
                                details.delta.dx / imageSize.width;
                        comparisonController.updateDividerPosition(newPosition);
                      },
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.drag_handle_rounded,
                            color: Colors.grey,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
                : const SizedBox.shrink();
          },
        );
      },
    );
  }

  Widget _buildComparisonLabel(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[700],
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}