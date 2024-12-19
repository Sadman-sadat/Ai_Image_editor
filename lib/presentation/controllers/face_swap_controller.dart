import 'package:get/get.dart';
import 'package:image_ai_editor/data/models/face_swap_model.dart';
import 'package:image_ai_editor/data/services/face_swap_service.dart';
import 'package:image_ai_editor/data/services/image_storage_service.dart';
import 'package:image_ai_editor/data/utility/urls.dart';
import 'package:image_ai_editor/presentation/controllers/fetch_queued_image_controller.dart';
import 'package:image_ai_editor/presentation/controllers/polling_result_controller.dart';
import 'package:image_ai_editor/presentation/controllers/processing_controller.dart';
import 'package:image_ai_editor/processing_type.dart';

class FaceSwapController extends ProcessingController with PollingResultMixin {
  final FaceSwapService _faceSwapService = FaceSwapService();
  final ImageStorageService _storageService = Get.find();
  final FetchQueuedImageController _fetchController = Get.find();

  String? _currentTargetImage;
  String? _currentImage;

  void setTargetImage(String targetImageBase64) {
    _currentTargetImage = targetImageBase64;
  }

  void setImage(String imageBase64) {
    _currentImage = imageBase64;
  }

  @override
  Future<bool> processImage(String base64Image) async {
    if (_currentTargetImage == null) {
      updateState(
          errorMessage: 'No target image provided for face swap',
          inProgress: false
      );
      return false;
    }

    return await swapFace(base64Image, _currentTargetImage!);
  }

  Future<bool> swapFace(String base64Original, String base64Target) async {
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
        processingType: ProcessingType.faceSwap.storageKey,
      );

      if (storedData != null && storedData['processedUrl']?.isNotEmpty == true) {
        updateState(
          resultImageUrl: storedData['processedUrl']!,
          inProgress: false,
        );
        return true;
      }

      FaceSwapModel model = FaceSwapModel(
        apiKey: Urls.api_Key,
        initImage: base64Original,
        targetImage: base64Target,
      );

      Map response = await _faceSwapService.swapFace(model);
      print('Face Swap Response: $response');

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
          processingType: ProcessingType.faceSwap.storageKey,
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

        // More aggressive polling
        await _startPollingForResult(base64Original, trackerId);

        // Check if image was successfully retrieved
        isSuccess = resultImageUrl.isNotEmpty;

        print('Polling result - Success: $isSuccess, Image URL: $resultImageUrl');
      }
    } catch (e, stackTrace) {
      updateState(
        errorMessage: 'Error in swapFace: $e',
        inProgress: false,
      );
      print('Face Swap Error: $errorMessage');
      print('Stack trace: $stackTrace');
    }

    return isSuccess;
  }

  Future<void> _startPollingForResult(String base64Image, String trackerId) async {
    await startPollingForResult(
      controller: this,
      base64Image: base64Image,
      trackerId: trackerId,
      processingType: ProcessingType.faceSwap,
    );
  }

  @override
  void clearCurrentProcess() {
    super.clearCurrentProcess();
    _currentTargetImage = null;
    _currentImage = null;
  }
}