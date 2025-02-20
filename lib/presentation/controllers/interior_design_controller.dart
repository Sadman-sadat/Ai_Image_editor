import 'package:appear_ai_image_editor/data/utility/urls.dart';
import 'package:get/get.dart';
import 'package:appear_ai_image_editor/data/models/interior_design_model.dart';
import 'package:appear_ai_image_editor/data/services/interior_design_service.dart';
import 'package:appear_ai_image_editor/presentation/controllers/fetch_queued_image_controller.dart';
import 'package:appear_ai_image_editor/presentation/controllers/polling_result_controller.dart';
import 'package:appear_ai_image_editor/presentation/controllers/processing_controller.dart';

class InteriorDesignController extends ProcessingController with PollingResultMixin {
  final InteriorDesignService _interiorService = InteriorDesignService();
  final FetchQueuedImageController _fetchController = Get.find();

  String? _currentInitImage;
  String? _currentPrompt;

  void setInitImage(String initImageUrl) {
    _currentInitImage = initImageUrl;
  }

  void setPrompt(String prompt) {
    _currentPrompt = prompt;
  }

  @override
  Future<bool> processImage(String base64Image) async {
    if (_currentInitImage == null || _currentPrompt == null) {
      updateState(
          errorMessage: 'Initial image or prompt not provided',
          inProgress: false
      );
      return false;
    }

    return await generateInteriorDesign(_currentInitImage!, _currentPrompt!);
  }

  Future<bool> generateInteriorDesign(String initImage, String prompt) async {
    bool isSuccess = false;
    _interiorService.resetCancellation();

    updateState(
      inProgress: true,
      errorMessage: '',
      resultImageUrl: '',
      trackedId: '',
    );

    try {
      InteriorDesignModel model = InteriorDesignModel(
        apiKey: Urls.api_Key,
        initImage: initImage,
        prompt: prompt,
      );

      Map<String, dynamic> response = await _interiorService.generateInteriorDesign(model);
      print('Interior Design Generation Response: $response');

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

        await _startPollingForResult(initImage, trackerId);

        isSuccess = resultImageUrl.isNotEmpty;
        print('Polling result - Success: $isSuccess, Image URL: $resultImageUrl');
      }
    } catch (e, stackTrace) {
      updateState(
        errorMessage: 'Error in generateInteriorDesign: $e',
        inProgress: false,
      );
      print('Interior Design Generation Error: $errorMessage');
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
    _currentInitImage = null;
    _currentPrompt = null;
    _interiorService.cancelRequest();
  }
  @override
  void cancelProcessing() {
    _interiorService.cancelRequest();
    _interiorService.markAsDisposed();
    super.cancelProcessing();
    clearCurrentProcess();
  }

  @override
  void onClose() {
    cancelProcessing();
    super.onClose();
  }
}