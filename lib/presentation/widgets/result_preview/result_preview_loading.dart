import 'package:flutter/material.dart';

class ResultPreviewLoading extends StatelessWidget {
  final bool isLoading;
  final String processingText;
  final double generationTime;

  const ResultPreviewLoading({
    super.key,
    required this.isLoading,
    required this.processingText,
    required this.generationTime,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 24),
          Text(
            isLoading ? processingText : 'Fetching processed image...',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
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
    );
  }
}