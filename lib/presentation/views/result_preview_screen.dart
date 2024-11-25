import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_ai_editor/data/services/download_image_service.dart';
import 'package:image_ai_editor/data/services/image_storage_service.dart';
import 'package:image_ai_editor/presentation/controllers/background_removal_controller.dart';
import 'package:image_ai_editor/presentation/controllers/fetch_queued_image_controller.dart';
import 'package:image_ai_editor/presentation/controllers/image_enhancement_controller.dart';
import 'package:image_ai_editor/presentation/controllers/object_removal_controller.dart';
import 'package:image_ai_editor/presentation/widgets/result_preview/result_preview_content.dart';
import 'package:image_ai_editor/presentation/widgets/result_preview/result_preview_error.dart';
import 'package:image_ai_editor/presentation/widgets/result_preview/result_preview_loading.dart';
import 'package:image_ai_editor/presentation/widgets/snack_bar_message.dart';
import 'package:image_ai_editor/processing_type.dart';

class ResultPreviewScreen extends StatefulWidget {
  final String base64Image;
  final ProcessingType processingType;

  const ResultPreviewScreen({
    super.key,
    required this.base64Image,
    required this.processingType,
  });

  @override
  State<ResultPreviewScreen> createState() => _ResultPreviewScreenState();
}

class _ResultPreviewScreenState extends State<ResultPreviewScreen> {
  late final dynamic activeController;
  late final FetchQueuedImageController _fetchQueuedImageController;
  final DownloadImageService _downloadService = Get.find<DownloadImageService>();

  @override
  void initState() {
    super.initState();
    activeController = _getControllerForType(widget.processingType);
    _fetchQueuedImageController = Get.find<FetchQueuedImageController>();
    _startProcessing();
  }

  dynamic _getControllerForType(ProcessingType type) {
    switch (type) {
      case ProcessingType.backgroundRemoval:
        return Get.find<BackgroundRemovalController>();
      case ProcessingType.imageEnhancement:
        return Get.find<ImageEnhancementController>();
      case ProcessingType.objectRemoval:
        return Get.find<ObjectRemovalController>();
    }
  }

  void _startProcessing() {
    switch (widget.processingType) {
      case ProcessingType.backgroundRemoval:
        activeController.removeBackground(widget.base64Image);
      case ProcessingType.imageEnhancement:
        activeController.enhanceImage(widget.base64Image);
      case ProcessingType.objectRemoval:
        activeController.removeObject(widget.base64Image);
    }
  }


  String get _activeImageUrl {
    if (_fetchQueuedImageController.fetchedImageUrl.value.isNotEmpty) {
      return _fetchQueuedImageController.fetchedImageUrl.value;
    }
    return activeController.resultImageUrl.value;
  }

  bool get _isProcessing =>
      activeController.isLoading.value ||
          _fetchQueuedImageController.isLoading.value ||
          (activeController.trackedId.value.isNotEmpty && _activeImageUrl.isEmpty);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.processingType.processingText,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Obx(() {
              return _isProcessing
                  ? LinearProgressIndicator(
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              )
                  : const SizedBox.shrink();
            }),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Obx(() {
                    if (_isProcessing) {
                      return ResultPreviewLoading(
                        isLoading: activeController.isLoading.value,
                        processingText: widget.processingType.processingText,
                        generationTime: activeController.generationTime.value,
                      );
                    }

                    if (_activeImageUrl.isNotEmpty) {
                      return ResultPreviewContent(
                        afterImageUrl: _activeImageUrl,
                        onRetry: _handleRetry,
                        onDownload: _downloadImage,beforeImageUrl: widget.base64Image,
                      );
                    }

                    return ResultPreviewError(onRetry: _handleRetry);
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _downloadImage(String imageUrl) async {
    try {
      showSnackBarMessage(
        title: 'Downloading',
        message: 'Saving image to gallery...',
        colorText: Colors.black,
      );

      await _downloadService.downloadAndSaveImage(imageUrl);

      showSnackBarMessage(
        title: 'Success',
        message: 'Image saved to gallery successfully',
        colorText: Colors.black,
      );
    } catch (e) {
      showSnackBarMessage(
        title: 'Error',
        message: 'Failed to save image: ${e.toString()}',
        colorText: Colors.red,
      );
    }
  }

  void _handleRetry() {
    _fetchQueuedImageController.clearFetchedImageUrl();
    activeController.clearCurrentProcess();

    final storageService = Get.find<ImageStorageService>();
    storageService.removeImageData(
      base64Image: widget.base64Image,
      processingType: widget.processingType.storageKey,
    );

    _startProcessing();
  }
}
