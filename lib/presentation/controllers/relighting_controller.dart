import 'package:get/get.dart';
import 'package:image_ai_editor/data/models/relighting_model.dart';
import 'package:image_ai_editor/data/services/image_storage_service.dart';
import 'package:image_ai_editor/data/services/relighting_service.dart';
import 'package:image_ai_editor/data/utility/urls.dart';
import 'package:image_ai_editor/presentation/controllers/fetch_queued_image_controller.dart';
import 'package:image_ai_editor/presentation/controllers/polling_result_controller.dart';
import 'package:image_ai_editor/presentation/controllers/processing_controller.dart';
import 'package:image_ai_editor/processing_type.dart';

class RelightingController extends ProcessingController with PollingResultMixin {
  final RelightingService _relightingService = RelightingService();
  final ImageStorageService _storageService = Get.find();
  final FetchQueuedImageController _fetchController = Get.find();

  String? _currentInitImage;
  String? _currentLighting;
  String? _currentPrompt;

  void setInitImage(String initImageUrl) {
    _currentInitImage = initImageUrl;
  }

  void setLighting(String lighting) {
    _currentLighting = lighting;
  }

  void setPrompt(String prompt) {
    _currentPrompt = prompt;
  }

  @override
  Future<bool> processImage(String base64Image) async {
    if (_currentInitImage == null || _currentLighting == null || _currentPrompt == null) {
      updateState(
          errorMessage: 'Initial image, lighting, or prompt not provided',
          inProgress: false
      );
      return false;
    }

    return await generateRelighting(_currentInitImage!, _currentLighting!, _currentPrompt!);
  }

  Future<bool> generateRelighting(String initImage, String lighting, String prompt) async {
    bool isSuccess = false;
    updateState(
      inProgress: true,
      errorMessage: '',
      resultImageUrl: '',
      trackedId: '',
    );

    try {
      final storedData = _storageService.getImageData(
        base64Image: initImage,
        processingType: ProcessingType.relighting.storageKey,
      );

      if (storedData != null && storedData['processedUrl']?.isNotEmpty == true) {
        updateState(
          resultImageUrl: storedData['processedUrl']!,
          inProgress: false,
        );
        return true;
      }

      RelightingModel model = RelightingModel(
        apiKey: Urls.api_Key,
        initImage: initImage,
        lighting: lighting,
        prompt: prompt,
      );

      Map<String, dynamic> response = await _relightingService.generateRelighting(model);
      print('Relighting Generation Response: $response');

      if (response.containsKey('output') && response['output'] != null) {
        updateState(
          resultImageUrl: response['output'],
          generationTime: response['generationTime'] ?? 0.0,
          inProgress: false,
        );

        _storageService.storeImageData(
          base64Image: initImage,
          processedUrl: resultImageUrl,
          processingType: ProcessingType.relighting.storageKey,
        );

        isSuccess = true;
      } else if (response.containsKey('id')) {
        final trackerId = response['id'].toString();
        print('Tracker ID received: $trackerId');

        updateState(
          trackedId: trackerId,
          generationTime: response['generationTime'] ?? 0.0,
        );

        await _startPollingForResult(initImage, trackerId);

        isSuccess = resultImageUrl.isNotEmpty;
        print('Polling result - Success: $isSuccess, Image URL: $resultImageUrl');
      }
    } catch (e, stackTrace) {
      updateState(
        errorMessage: 'Error in generateRelighting: $e',
        inProgress: false,
      );
      print('Relighting Generation Error: $errorMessage');
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
    super.clearCurrentProcess();
    _currentInitImage = null;
    _currentLighting = null;
    _currentPrompt = null;
  }
}