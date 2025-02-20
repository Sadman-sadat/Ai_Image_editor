import 'package:get/get.dart';
import 'package:appear_ai_image_editor/data/models/head_shot_gen_model.dart';
import 'package:appear_ai_image_editor/data/services/head_shot_gen_service.dart';
import 'package:appear_ai_image_editor/data/utility/urls.dart';
import 'package:appear_ai_image_editor/presentation/controllers/fetch_queued_image_controller.dart';
import 'package:appear_ai_image_editor/presentation/controllers/polling_result_controller.dart';
import 'package:appear_ai_image_editor/presentation/controllers/processing_controller.dart';
import 'package:appear_ai_image_editor/processing_type.dart';

class HeadShotGenController extends ProcessingController with PollingResultMixin {
  final HeadShotGenService _headShotService = HeadShotGenService();
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
    _headShotService.resetCancellation();

    updateState(
      inProgress: true,
      errorMessage: '',
      resultImageUrl: '',
      trackedId: '',
    );

    try {
      HeadShotGenModel model = HeadShotGenModel(
        apiKey: Urls.api_Key,
        faceImage: base64Original,
        prompt: prompt,
      );

      Map<String, dynamic> response = await _headShotService.generateHeadShot(model);
      print('Headshot Generation Response: $response');

      if (response.containsKey('output') && response['output'] != null) {
        updateState(
          resultImageUrl: response['output'],
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

        await _startPollingForResult(base64Original, trackerId);

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
    await startPollingForResult(
      controller: this,
      trackerId: trackerId,
    );
  }

  @override
  void clearCurrentProcess() {
    super.clearCurrentProcess();
    _currentFaceImage = null;
    _currentPrompt = null;
    _headShotService.cancelRequest();
  }

  @override
  void cancelProcessing() {
    _headShotService.cancelRequest();
    _headShotService.markAsDisposed();
    super.cancelProcessing();
    clearCurrentProcess();
  }

  @override
  void onClose() {
    cancelProcessing();
    super.onClose();
  }
}
