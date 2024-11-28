import 'package:get/get.dart';
import 'package:image_ai_editor/data/models/background_removal_model.dart';
import 'package:image_ai_editor/data/services/background_removal_service.dart';
import 'package:image_ai_editor/data/services/image_storage_service.dart';
import 'package:image_ai_editor/data/utility/urls.dart';
import 'package:image_ai_editor/presentation/controllers/fetch_queued_image_controller.dart';
import 'package:image_ai_editor/presentation/controllers/processing_controller.dart';
import 'package:image_ai_editor/processing_type.dart';

class BackgroundRemovalController extends ProcessingController {
  final BackgroundRemovalService _backgroundRemovalService = BackgroundRemovalService();
  final ImageStorageService _storageService = Get.find();
  final FetchQueuedImageController _fetchController = Get.find();

  @override
  Future<bool> processImage(String base64Image) async {
    return await removeBackground(base64Image);
  }

  Future<bool> removeBackground(String base64Image) async {
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
        processingType: ProcessingType.backgroundRemoval.storageKey,
      );

      if (storedData != null && storedData['processedUrl']?.isNotEmpty == true) {
        updateState(
          resultImageUrl: storedData['processedUrl']!,
          inProgress: false,
        );
        return true;
      }

      BackgroundRemovalModel model = BackgroundRemovalModel(
        apiKey: Urls.api_Key,
        image: base64Image,
        onlyMask: false,
      );

      Map response = await _backgroundRemovalService.removeBackground(model);
      print('Background Removal Response: $response'); // Diagnostic print

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
          processingType: ProcessingType.backgroundRemoval.storageKey,
        );

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
        errorMessage: 'Error in removeBackground: $e',
        inProgress: false,
      );
      print('Background Removal Error: $errorMessage');
      print('Stack trace: $stackTrace');
    }

    return isSuccess;
  }

  Future<void> _startPollingForResult(String base64Image, String trackerId) async {
    print('Starting polling for trackerId: $trackerId'); // Diagnostic print

    int maxAttempts = 20; // Increased number of attempts
    int attempts = 0;
    bool imageFound = false;

    while (attempts < maxAttempts && !imageFound) {
      print('Polling attempt $attempts'); // Diagnostic print

      // Try to fetch the queued image
      bool fetchResult = await _fetchController.fetchQueuedImage(
        trackerId,
        base64Image: base64Image,
        processingType: ProcessingType.backgroundRemoval.storageKey,
      );

      print('Fetch attempt result: $fetchResult'); // Diagnostic print
      print('Fetched Image URL: ${_fetchController.fetchedImageUrl}'); // Diagnostic print

      if (_fetchController.fetchedImageUrl.isNotEmpty) {
        updateState(
          resultImageUrl: _fetchController.fetchedImageUrl,
          inProgress: false,
        );
        imageFound = true;
        break;
      }

      // Exponential backoff: wait longer between attempts
      await Future.delayed(Duration(seconds: 3 * (attempts + 1)));
      attempts++;
    }

    if (!imageFound) {
      updateState(
        errorMessage: 'Could not retrieve processed image after $maxAttempts attempts',
        inProgress: false,
      );
      print('Failed to retrieve image after multiple attempts'); // Diagnostic print
    }
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
