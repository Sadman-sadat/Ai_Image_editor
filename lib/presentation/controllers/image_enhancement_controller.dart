import 'package:get/get.dart';
import 'package:image_ai_editor/data/models/image_enhancement_model.dart';
import 'package:image_ai_editor/data/services/image_enhancement_service.dart';
import 'package:image_ai_editor/data/services/image_storage_service.dart';
import 'package:image_ai_editor/data/utility/urls.dart';
import 'package:image_ai_editor/presentation/controllers/fetch_queued_image_controller.dart';
import 'package:image_ai_editor/presentation/controllers/polling_result_controller.dart';
import 'package:image_ai_editor/presentation/controllers/processing_controller.dart';
import 'package:image_ai_editor/processing_type.dart';

class ImageEnhancementController extends ProcessingController with PollingResultMixin {
  final ImageEnhancementService _imageEnhancementService = ImageEnhancementService();
  final ImageStorageService _storageService = Get.find();
  final FetchQueuedImageController _fetchController = Get.find();

  @override
  Future<bool> processImage(String base64Image) async {
    return await enhanceImage(base64Image);
  }

  Future<bool> enhanceImage(String base64Image) async {
    bool isSuccess = false;
    updateState(
      inProgress: true,
      errorMessage: '',
      resultImageUrl: '',
      trackedId: '',
    );

    try {
      // Check storage first
      final storedData = _storageService.getImageData(
        base64Image: base64Image,
        processingType: ProcessingType.imageEnhancement.storageKey,
      );

      if (storedData != null && storedData['processedUrl']?.isNotEmpty == true) {
        updateState(
          resultImageUrl: storedData['processedUrl']!,
          inProgress: false,
        );
        return true;
      }

      ImageEnhancementModel model = ImageEnhancementModel(
        apiKey: Urls.api_Key,
        image: base64Image,
      );

      Map response = await _imageEnhancementService.enhancementImage(model);
      print('Image Enhancement Response: $response'); // Diagnostic print

      if (response.containsKey('output') && response['output'] != null) {
        // Immediate output available
        updateState(
          resultImageUrl: response['output'],
          generationTime: response['generationTime'] ?? 0.0,
          inProgress: false,
        );

        // Store the processed image
        _storageService.storeImageData(
          base64Image: base64Image,
          processedUrl: resultImageUrl,
          processingType: ProcessingType.imageEnhancement.storageKey,
        );

        //extra update for some reason here it doesn't update with updateState
        update();
        isSuccess = true;
      } else if (response.containsKey('id')) {
        // Queued processing, need to poll
        final trackerId = response['id'].toString();
        print('Tracker ID received: $trackerId'); // Diagnostic print

        updateState(
          trackedId: trackerId,
          generationTime: response['generationTime'] ?? 0.0,
        );

        // More aggressive polling
        await _startPollingForResult(base64Image, trackerId);

        // Check if image was successfully retrieved
        isSuccess = resultImageUrl.isNotEmpty;

        print('Polling result - Success: $isSuccess, Image URL: $resultImageUrl'); // Diagnostic print
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
      base64Image: base64Image,
      trackerId: trackerId,
      processingType: ProcessingType.backgroundRemoval,
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
  }
}
