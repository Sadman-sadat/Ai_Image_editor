import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_ai_editor/presentation/controllers/comparison_controller.dart';
import 'package:image_ai_editor/presentation/widgets/result_preview/result_preview_comparison_overlay.dart';
import 'package:image_ai_editor/presentation/widgets/result_preview/result_preview_error.dart';

class ResultPreviewContent extends StatelessWidget {
  final String beforeImageUrl;
  final String afterImageUrl;
  final VoidCallback onRetry;
  final Function(String) onDownload;
  final GlobalKey _imageKey = GlobalKey();

  ResultPreviewContent({
    super.key,
    required this.beforeImageUrl,
    required this.afterImageUrl,
    required this.onRetry,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Stack(
            fit: StackFit.expand,
            children: [
              // After Image (Full Background)
              Center(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Image.network(
                    afterImageUrl,
                    key: _imageKey,
                    fit: BoxFit.contain,
                    loadingBuilder: _imageLoadingBuilder,
                    errorBuilder: (_, __, ___) =>
                        ResultPreviewError(onRetry: onRetry),
                  ),
                ),
              ),

              // Before Image (Clipped)
              GetBuilder<ComparisonController>(
                builder: (comparisonController) {
                  return Center(
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: AnimatedOpacity(
                        opacity: comparisonController.isComparisonMode ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 300),
                        child: ResultPreviewComparisonOverlay(
                          imageKey: _imageKey,
                          beforeImageUrl: beforeImageUrl,
                          onRetry: onRetry,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        _buildActionButtons(),
      ],
    );
  }

  Widget _imageLoadingBuilder(
      BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
    if (loadingProgress == null) return child;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                loadingProgress.expectedTotalBytes!
                : null,
          ),
          const SizedBox(height: 16),
          const Text(
            'Loading image...',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(20),
                ),
                child: const Icon(Icons.refresh_rounded),
              ),
              const SizedBox(height: 8),
              const Text('Retry',
                  style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500)),
            ],
          ),
          Column(
            children: [
              ElevatedButton(
                onPressed: () => onDownload(afterImageUrl),
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(20),
                ),
                child: const Icon(Icons.download_rounded),
              ),
              const SizedBox(height: 8),
              const Text('Download',
                  style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }
}
