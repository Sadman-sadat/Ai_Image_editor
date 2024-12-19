import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_ai_editor/data/services/download_image_service.dart';
import 'package:image_ai_editor/data/services/image_storage_service.dart';
import 'package:image_ai_editor/presentation/controllers/avatar_gen_controller.dart';
import 'package:image_ai_editor/presentation/controllers/background_removal_controller.dart';
import 'package:image_ai_editor/presentation/controllers/comparison_controller.dart';
import 'package:image_ai_editor/presentation/controllers/face_swap_controller.dart';
import 'package:image_ai_editor/presentation/controllers/fetch_queued_image_controller.dart';
import 'package:image_ai_editor/presentation/controllers/head_shot_gen_controller.dart';
import 'package:image_ai_editor/presentation/controllers/image_enhancement_controller.dart';
import 'package:image_ai_editor/presentation/controllers/object_removal_controller.dart';
import 'package:image_ai_editor/presentation/controllers/processing_controller.dart';
import 'package:image_ai_editor/presentation/controllers/relighting_controller.dart';
import 'package:image_ai_editor/presentation/widgets/result_preview/result_preview_content.dart';
import 'package:image_ai_editor/presentation/widgets/result_preview/result_preview_error.dart';
import 'package:image_ai_editor/presentation/widgets/result_preview/result_preview_loading.dart';
import 'package:image_ai_editor/presentation/widgets/snack_bar_message.dart';
import 'package:image_ai_editor/processing_type.dart';

class ResultPreviewScreen extends StatefulWidget {
  final String base64Image;
  final ProcessingType processingType;
  final String? maskImage;
  final String? textPrompt;
  final String? positionLighting;
  final bool? comparisonMode;

  const ResultPreviewScreen(
      {super.key,
      required this.base64Image,
      required this.processingType,
      this.maskImage,
      this.textPrompt,
      this.comparisonMode, this.positionLighting});

  @override
  State<ResultPreviewScreen> createState() => _ResultPreviewScreenState();
}

class _ResultPreviewScreenState extends State<ResultPreviewScreen> {
  late ProcessingController activeController;
  late final FetchQueuedImageController _fetchQueuedImageController;
  final DownloadImageService _downloadService =
      Get.find<DownloadImageService>();

  @override
  void initState() {
    super.initState();
    activeController = _getControllerForType(widget.processingType);
    _fetchQueuedImageController = Get.find<FetchQueuedImageController>();
    _startProcessing();
  }

  ProcessingController _getControllerForType(ProcessingType type) {
    switch (type) {
      case ProcessingType.backgroundRemoval:
        return Get.find<BackgroundRemovalController>();
      case ProcessingType.imageEnhancement:
        return Get.find<ImageEnhancementController>();
      case ProcessingType.objectRemoval:
        return Get.find<ObjectRemovalController>();
      case ProcessingType.headShotGen:
        return Get.find<HeadShotGenController>();
      case ProcessingType.relighting:
        return Get.find<RelightingController>();
      case ProcessingType.avatarGen:
        return Get.find<AvatarGenController>();
      case ProcessingType.faceSwap:
        return Get.find<FaceSwapController>();
    }
  }

  void _startProcessing() {
    switch (widget.processingType) {
      case ProcessingType.backgroundRemoval:
        (activeController as BackgroundRemovalController)
            .removeBackground(widget.base64Image);
        break;
      case ProcessingType.imageEnhancement:
        if (widget.base64Image.isNotEmpty) {
          (activeController as ImageEnhancementController)
              .enhanceImage(widget.base64Image);
        } else {
          showSnackBarMessage(
            title: 'Error',
            message: 'Base Image is required for Image Enhancement',
            colorText: Colors.red,
          );
        }
        break;
      case ProcessingType.objectRemoval:
        if (widget.maskImage != null) {
          (activeController as ObjectRemovalController)
              .removeObject(widget.base64Image, widget.maskImage!);
        } else {
          showSnackBarMessage(
            title: 'Error',
            message: 'Mask image is required for object removal',
            colorText: Colors.red,
          );
        }
        break;
      case ProcessingType.headShotGen:
        if (widget.textPrompt != null) {
          (activeController as HeadShotGenController)
              .generateHeadShot(widget.base64Image, widget.textPrompt!);
        } else {
          showSnackBarMessage(
            title: 'Error',
            message: 'Prompt Text is required for Face gen',
            colorText: Colors.red,
          );
        }
        break;
      case ProcessingType.relighting:
        if (widget.textPrompt != null) {
          (activeController as RelightingController)
              .generateRelighting(widget.base64Image, widget.positionLighting!, widget.textPrompt!);
        } else {
          showSnackBarMessage(
            title: 'Error',
            message: 'Prompt Text is required for Relighting',
            colorText: Colors.red,
          );
        }
      case ProcessingType.avatarGen:
      if (widget.textPrompt != null) {
        (activeController as AvatarGenController)
            .generateAvatar(widget.base64Image, widget.textPrompt!);
      } else {
        showSnackBarMessage(
          title: 'Error',
          message: 'Prompt Text is required for Avatar Generator',
          colorText: Colors.red,
        );
      }
      case ProcessingType.faceSwap:
        (activeController as FaceSwapController)
            .swapFace(widget.maskImage!, widget.base64Image);
        break;
    }
  }

  String _getActiveImageUrl() {
    if (_fetchQueuedImageController.fetchedImageUrl.isNotEmpty) {
      return _fetchQueuedImageController.fetchedImageUrl;
    }
    return activeController.resultImageUrl;
  }

  bool _checkIsProcessing() {
    return activeController.inProgress ||
        _fetchQueuedImageController.inProgress ||
        (activeController.trackedId.isNotEmpty && _getActiveImageUrl().isEmpty);
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
          actions: [
            GetBuilder<ComparisonController>(
              builder: (comparisonController) {
                if (widget.comparisonMode ?? false) {
                  return IconButton(
                    icon: Icon(
                      comparisonController.isComparisonMode
                          ? Icons.compare_arrows_rounded
                          : Icons.compare_outlined,
                      color: Colors.white,
                    ),
                    onPressed: comparisonController.toggleComparisonMode,
                  );
                } else {
                  // Return an empty container if comparisonMode is false
                  return Container();
                }
              },
            )
          ]),
      body: SafeArea(
        child: Column(
          children: [
            GetBuilder<ProcessingController>(
              init: activeController,
              builder: (_) => _checkIsProcessing()
                  ? LinearProgressIndicator(
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
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
                  child: GetBuilder<FetchQueuedImageController>(
                    init: _fetchQueuedImageController,
                    builder: (fetchController) {
                      return GetBuilder<ProcessingController>(
                        init: activeController,
                        builder: (controller) {
                          final isProcessing = _checkIsProcessing();
                          final activeImageUrl = _getActiveImageUrl();

                          if (isProcessing) {
                            return ResultPreviewLoading(
                              isLoading: controller.inProgress,
                              processingText:
                                  widget.processingType.processingText,
                              generationTime: controller.generationTime,
                            );
                          }

                          if (activeImageUrl.isNotEmpty) {
                            return ResultPreviewContent(
                              afterImageUrl: activeImageUrl,
                              beforeImageUrl: widget.base64Image,
                              onRetry: _handleRetry,
                              onDownload: _downloadImage,
                            );
                          }
                          return ResultPreviewError(onRetry: _handleRetry);
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
