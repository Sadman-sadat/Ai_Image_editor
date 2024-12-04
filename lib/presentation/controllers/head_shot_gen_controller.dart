import 'package:get/get.dart';
import 'package:image_ai_editor/data/models/head_shot_gen_model.dart';
import 'package:image_ai_editor/data/services/head_shot_gen_service.dart';
import 'package:image_ai_editor/data/services/image_storage_service.dart';
import 'package:image_ai_editor/data/utility/urls.dart';
import 'package:image_ai_editor/presentation/controllers/fetch_queued_image_controller.dart';
import 'package:image_ai_editor/presentation/controllers/processing_controller.dart';
import 'package:image_ai_editor/processing_type.dart';

class HeadShotGenController extends ProcessingController {
  final HeadShotGenService _headShotService = HeadShotGenService();
  final ImageStorageService _storageService = Get.find();
  final FetchQueuedImageController _fetchController = Get.find();

  String? _currentFaceImage;
  String? _currentPrompt;

  void setFaceImage(String faceImageBase64) {
    _currentFaceImage = faceImageBase64;
  }

  void setPrompt(String prompt) {
    _currentPrompt = prompt;
  }

  @override
  Future<bool> processImage(String base64Image) async {
    if (_currentFaceImage == null || _currentPrompt == null) {
      updateState(
          errorMessage: 'Face image or prompt not provided',
          inProgress: false
      );
      return false;
    }

    return await generateHeadShot(base64Image, _currentPrompt!);
  }

  Future<bool> generateHeadShot(String base64Original, String prompt) async {
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
        base64Image: base64Original,
        processingType: ProcessingType.headShotGen.storageKey,
      );

      if (storedData != null && storedData['processedUrl']?.isNotEmpty == true) {
        updateState(
          resultImageUrl: storedData['processedUrl']!,
          inProgress: false,
        );
        return true;
      }

      HeadShotGenModel model = HeadShotGenModel(
        apiKey: Urls.api_Key,
        faceImage: base64Original,
        prompt: prompt,
      );

      Map<String, dynamic> response = await _headShotService.generateHeadShot(model);
      print('Headshot Generation Response: $response');

      if (response.containsKey('output') && response['output'] != null) {
        // Immediate output available
        updateState(
          resultImageUrl: response['output'],
          generationTime: response['generationTime'] ?? 0.0,
          inProgress: false,
        );

        // Store the processed image
        _storageService.storeImageData(
          base64Image: base64Original,
          processedUrl: resultImageUrl,
          processingType: ProcessingType.headShotGen.storageKey,
        );

        isSuccess = true;
      } else if (response.containsKey('id')) {
        // Queued processing, need to poll
        final trackerId = response['id'].toString();
        print('Tracker ID received: $trackerId');

        updateState(
          trackedId: trackerId,
          generationTime: response['generationTime'] ?? 0.0,
        );

        // Poll for result
        await _startPollingForResult(base64Original, trackerId);

        // Check if image was successfully retrieved
        isSuccess = resultImageUrl.isNotEmpty;

        print('Polling result - Success: $isSuccess, Image URL: $resultImageUrl');
      }
    } catch (e, stackTrace) {
      updateState(
        errorMessage: 'Error in generateHeadShot: $e',
        inProgress: false,
      );
      print('Headshot Generation Error: $errorMessage');
      print('Stack trace: $stackTrace');
    }

    return isSuccess;
  }

  Future<void> _startPollingForResult(String base64Image, String trackerId) async {
    print('Starting polling for trackerId: $trackerId');

    int maxAttempts = 20;
    int attempts = 0;
    bool imageFound = false;

    while (attempts < maxAttempts && !imageFound) {
      print('Polling attempt $attempts');

      bool fetchResult = await _fetchController.fetchQueuedImage(
        trackerId,
        base64Image: base64Image,
        processingType: ProcessingType.headShotGen.storageKey,
      );

      print('Fetch attempt result: $fetchResult');
      print('Fetched Image URL: ${_fetchController.fetchedImageUrl}');

      if (_fetchController.fetchedImageUrl.isNotEmpty) {
        updateState(
          resultImageUrl: _fetchController.fetchedImageUrl,
          inProgress: false,
        );
        imageFound = true;
        break;
      }

      // Exponential backoff
      await Future.delayed(Duration(seconds: 3 * (attempts + 1)));
      attempts++;
    }

    if (!imageFound) {
      updateState(
        errorMessage: 'Could not retrieve processed image after $maxAttempts attempts',
        inProgress: false,
      );
      print('Failed to retrieve image after multiple attempts');
    }
  }

  @override
  void clearCurrentProcess() {
    super.clearCurrentProcess();
    _currentFaceImage = null;
    _currentPrompt = null;
  }
}