import 'package:appear_ai_image_editor/presentation/widgets/ads/interstitial_ad_widget.dart';
import 'package:appear_ai_image_editor/presentation/widgets/result_preview/result_preview_action_buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:appear_ai_image_editor/presentation/controllers/result_preview/result_screen_image_comparison_controller.dart';
import 'package:appear_ai_image_editor/presentation/widgets/result_preview/result_preview_comparison_overlay.dart';
import 'package:appear_ai_image_editor/presentation/widgets/result_preview/result_preview_error.dart';

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
              Center(
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Container(
                    constraints: const BoxConstraints(
                      maxWidth: double.infinity,
                      maxHeight: double.infinity,
                    ),
                    child: Image.network(
                      afterImageUrl,
                      key: _imageKey,
                      fit: BoxFit.contain,
                      loadingBuilder: _imageLoadingBuilder,
                      errorBuilder: (context, error, stackTrace) {
                        print("Error loading image: $afterImageUrl");
                        print("Error details: $error");
                        return ResultPreviewError(onRetry: onRetry);
                      },
                    ),
                  ),
                ),
              ),
              GetBuilder<ComparisonController>(
                builder: (comparisonController) {
                  return Center(
                    child: SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: AnimatedOpacity(
                        opacity: comparisonController.isComparisonMode
                            ? 1.0
                            : 0.0,
                        duration: const Duration(milliseconds: 300),
                        child: ResultPreviewComparisonOverlay (
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

  Widget _imageLoadingBuilder(BuildContext context, Widget child,
      ImageChunkEvent? loadingProgress) {
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
          InterstitialAdWidget(
            onSuccess: onRetry,
            child: const ResultPreviewActionButtons(
              icon: Icons.refresh_rounded,
              label: 'Retry',
            ),
          ),
          ResultPreviewActionButtons(
            onPressed: () => onDownload(afterImageUrl),
            icon: Icons.download_rounded,
            label: 'Download',
          ),
        ],
      ),
    );
  }
}
