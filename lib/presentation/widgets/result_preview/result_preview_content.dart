import 'package:flutter/material.dart';
import 'package:image_ai_editor/presentation/widgets/result_preview/result_preview_error.dart';

class ResultPreviewContent extends StatefulWidget {
  final String beforeImageUrl;
  final String afterImageUrl;
  final VoidCallback onRetry;
  final Function(String) onDownload;

  const ResultPreviewContent({
    super.key,
    required this.beforeImageUrl,
    required this.afterImageUrl,
    required this.onRetry,
    required this.onDownload,
  });

  @override
  _ResultPreviewContentState createState() => _ResultPreviewContentState();
}

class _ResultPreviewContentState extends State<ResultPreviewContent> {
  double _dividerPosition = 0.5;
  bool _isComparisonMode = false;
  final GlobalKey _imageKey = GlobalKey();

  void _toggleComparisonMode() {
    setState(() {
      _isComparisonMode = !_isComparisonMode;
      _dividerPosition = 0.5;
    });
  }

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
                    widget.afterImageUrl,
                    key: _imageKey,
                    fit: BoxFit.contain,
                    loadingBuilder: _imageLoadingBuilder,
                    errorBuilder: (_, __, ___) => ResultPreviewError(onRetry: widget.onRetry),
                  ),
                ),
              ),

              // Before Image (Clipped)
              Center(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: AnimatedOpacity(
                    opacity: _isComparisonMode ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: ClipRect(
                      clipper: _ComparisonClipper(_dividerPosition),
                      child: Image.network(
                        widget.beforeImageUrl,
                        fit: BoxFit.contain,
                        loadingBuilder: _imageLoadingBuilder,
                        errorBuilder: (_, __, ___) => ResultPreviewError(onRetry: widget.onRetry),
                      ),
                    ),
                  ),
                ),
              ),

              // Updated Draggable Comparison Line
              if (_isComparisonMode)
                Center(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final RenderBox? imageBox = _imageKey.currentContext?.findRenderObject() as RenderBox?;
                      if (imageBox == null) return const SizedBox.shrink();

                      final imageSize = imageBox.size;
                      final imageOffset = imageBox.localToGlobal(Offset.zero);
                      final containerBox = context.findRenderObject() as RenderBox;
                      final containerOffset = containerBox.localToGlobal(Offset.zero);

                      // Calculate relative position within the container
                      final relativeImageOffset = Offset(
                        imageOffset.dx - containerOffset.dx,
                        imageOffset.dy - containerOffset.dy,
                      );

                      return SizedBox(
                        width: imageSize.width,
                        height: imageSize.height,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            // Vertical divider line
                            Positioned(
                              left: imageSize.width * _dividerPosition - 1.5,
                              top: 0,
                              child: GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onHorizontalDragUpdate: (details) {
                                  final double newPosition = _dividerPosition +
                                      details.delta.dx / imageSize.width;
                                  if (newPosition >= 0.05 && newPosition <= 0.95) {
                                    setState(() {
                                      _dividerPosition = newPosition;
                                    });
                                  }
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
                              left: imageSize.width * _dividerPosition - 15,
                              top: imageSize.height * 0.5 - 15,
                              child: GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onHorizontalDragUpdate: (details) {
                                  final double newPosition = _dividerPosition +
                                      details.delta.dx / imageSize.width;
                                  if (newPosition >= 0.04 && newPosition <= 0.96) {
                                    setState(() {
                                      _dividerPosition = newPosition;
                                    });
                                  }
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
                      );
                    },
                  ),
                ),

              // Comparison Mode Toggle Button
              Positioned(
                top: 16,
                right: 16,
                child: IconButton(
                  icon: Icon(
                    _isComparisonMode
                        ? Icons.compare_arrows_rounded
                        : Icons.compare_outlined,
                    color: Colors.white,
                    size: 32,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black.withOpacity(0.5),
                    shape: const CircleBorder(),
                  ),
                  onPressed: _toggleComparisonMode,
                ),
              ),
            ],
          ),
        ),
        _buildActionButtons(),
      ],
    );
  }

  Widget _imageLoadingBuilder(
      BuildContext context,
      Widget child,
      ImageChunkEvent? loadingProgress,
      ) {
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
                onPressed: widget.onRetry,
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
                onPressed: () => widget.onDownload(widget.afterImageUrl),
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

class _ComparisonClipper extends CustomClipper<Rect> {
  final double progress;

  _ComparisonClipper(this.progress);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(0, 0, size.width * progress, size.height);
  }

  @override
  bool shouldReclip(_ComparisonClipper oldClipper) {
    return oldClipper.progress != progress;
  }
}
