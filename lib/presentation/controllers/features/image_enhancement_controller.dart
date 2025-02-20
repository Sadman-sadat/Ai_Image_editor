// remove double update code delayed
import 'package:appear_ai_image_editor/presentation/controllers/image_processing/image_processing_settings_controller.dart';
import 'package:get/get.dart';
import 'package:appear_ai_image_editor/data/models/image_enhancement_model.dart';
import 'package:appear_ai_image_editor/data/services/features/image_enhancement_service.dart';
import 'package:appear_ai_image_editor/data/utility/urls.dart';
import 'package:appear_ai_image_editor/presentation/controllers/fetch_queued_image_controller.dart';
import 'package:appear_ai_image_editor/presentation/controllers/result_preview/result_controller_polling.dart';
import 'package:appear_ai_image_editor/presentation/controllers/result_preview/result_controller_processing_controller.dart';
import 'package:appear_ai_image_editor/processing_type.dart';

class ImageEnhancementController extends ProcessingController with PollingResultMixin {
  final ImageEnhancementService _imageEnhancementService = ImageEnhancementService();
  final FetchQueuedImageController _fetchController = Get.find();
  final ImageProcessingSettingsController _settingsController = Get.find();

  @override
  Future<bool> processImage(String base64Image) async {
    return await enhanceImage(base64Image);
  }

  Future<bool> enhanceImage(String base64Image) async {
    bool isSuccess = false;
    _imageEnhancementService.resetCancellation();

    updateState(
      inProgress: true,
      errorMessage: '',
      resultImageUrl: '',
      trackedId: '',
    );

    try {
      ImageEnhancementModel model = ImageEnhancementModel(
        apiKey: Urls.api_Key,
        image: base64Image,
        scale: _settingsController.scale,
      );

      Map response = await _imageEnhancementService.enhancementImage(model);
      print('Image Enhancement Response: $response');

      if (response.containsKey('output') && response['output'] != null) {
        // updateState(
        //   resultImageUrl: response['output'],
        //   generationTime: response['generationTime'] ?? 0.0,
        //   inProgress: false,
        // );

        final imageUrl = response['output'];

        // ✅ Wait before assigning URL
        await Future.delayed(Duration(seconds: 10));  // Adjust delay if needed

        updateState(
          resultImageUrl: imageUrl,
          generationTime: response['generationTime'] ?? 0.0,
          inProgress: false,
        );

        isSuccess = true;
      } else if (response.containsKey('id')) {
        final trackerId = response['id'].toString();
        print('Tracker ID received: $trackerId');

        updateState(
          trackedId: trackerId,
          generationTime: response['generationTime'] ?? 0.0,
        );

        await _startPollingForResult(base64Image, trackerId);

        isSuccess = resultImageUrl.isNotEmpty;
        print('Polling result - Success: $isSuccess, Image URL: $resultImageUrl');
      }
    } catch (e, stackTrace) {
      updateState(
        errorMessage: 'Error in enhanceImage: $e',
        inProgress: false,
      );
      print('Image Enhancement Error: $errorMessage');
      print('Stack trace: $stackTrace');
    }

    return isSuccess;
  }

  Future<void> _startPollingForResult(String base64Image, String trackerId) async {
    await startPollingForResult(
      controller: this,
      trackerId: trackerId,
    );
  }

  @override
  void clearCurrentProcess() {
    updateState(
      resultImageUrl: '',
      trackedId: '',
      errorMessage: '',
      inProgress: false,
    );
    _fetchController.clearFetchedImageUrl();
    _imageEnhancementService.cancelRequest();
  }

  @override
  void cancelProcessing() {
    _imageEnhancementService.cancelRequest();
    _imageEnhancementService.markAsDisposed();
    super.cancelProcessing();
    clearCurrentProcess();
  }

  @override
  void onClose() {
    cancelProcessing();
    super.onClose();
  }
}
