import 'package:get/get.dart';
import 'package:appear_ai_image_editor/data/models/face_swap_model.dart';
import 'package:appear_ai_image_editor/data/services/face_swap_service.dart';
import 'package:appear_ai_image_editor/data/utility/urls.dart';
import 'package:appear_ai_image_editor/presentation/controllers/fetch_queued_image_controller.dart';
import 'package:appear_ai_image_editor/presentation/controllers/polling_result_controller.dart';
import 'package:appear_ai_image_editor/presentation/controllers/processing_controller.dart';
import 'package:appear_ai_image_editor/processing_type.dart';

class FaceSwapController extends ProcessingController with PollingResultMixin {
  final FaceSwapService _faceSwapService = FaceSwapService();
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
        inProgress: false,
      );
      return false;
    }

    return await swapFace(base64Image, _currentTargetImage!);
  }

  Future<bool> swapFace(String base64Original, String base64Target) async {
    bool isSuccess = false;
    _faceSwapService.resetCancellation();
    updateState(
      inProgress: true,
      errorMessage: '',
      resultImageUrl: '',
      trackedId: '',
    );

    try {
      // Initialize the face swap process
      FaceSwapModel model = FaceSwapModel(
        apiKey: Urls.api_Key,
        initImage: base64Target,
        targetImage: base64Original,
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
      trackerId: trackerId,
    );
  }

  @override
  void clearCurrentProcess() {
    super.clearCurrentProcess();
    _currentTargetImage = null;
    _currentImage = null;
    _faceSwapService.resetCancellation();
  }

  @override
  void cancelProcessing() {
    _faceSwapService.cancelRequest();
    _faceSwapService.markAsDisposed();
    super.cancelProcessing();
    clearCurrentProcess();
  }

  @override
  void onClose() {
    cancelProcessing();
    super.onClose();
  }
}
