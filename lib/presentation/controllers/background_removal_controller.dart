import 'package:get/get.dart';
import 'package:appear_ai_image_editor/data/models/background_removal_model.dart';
import 'package:appear_ai_image_editor/data/services/background_removal_service.dart';
import 'package:appear_ai_image_editor/data/utility/urls.dart';
import 'package:appear_ai_image_editor/presentation/controllers/fetch_queued_image_controller.dart';
import 'package:appear_ai_image_editor/presentation/controllers/polling_result_controller.dart';
import 'package:appear_ai_image_editor/presentation/controllers/processing_controller.dart';
import 'package:appear_ai_image_editor/processing_type.dart';

class BackgroundRemovalController extends ProcessingController with PollingResultMixin {
  final BackgroundRemovalService _backgroundRemovalService = BackgroundRemovalService();
  final FetchQueuedImageController _fetchController = Get.find();

  @override
  Future<bool> processImage(String base64Image) async {
    return await removeBackground(base64Image);
  }

  Future<bool> removeBackground(String base64Image) async {
    bool isSuccess = false;
    _backgroundRemovalService.resetCancellation();

    updateState(
      inProgress: true,
      errorMessage: '',
      resultImageUrl: '',
      trackedId: '',
    );

    try {
      BackgroundRemovalModel model = BackgroundRemovalModel(
        apiKey: Urls.api_Key,
        image: base64Image,
        onlyMask: false,
      );

      Map response = await _backgroundRemovalService.removeBackground(model);
      print('Background Removal Response: $response');

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

        await _startPollingForResult(base64Image, trackerId);

        isSuccess = resultImageUrl.isNotEmpty;
        print('Polling result - Success: $isSuccess, Image URL: $resultImageUrl');
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
    _backgroundRemovalService.cancelRequest();
  }

  @override
  void cancelProcessing() {
    _backgroundRemovalService.cancelRequest();
    _backgroundRemovalService.markAsDisposed();
    super.cancelProcessing();
    clearCurrentProcess();
  }

  @override
  void onClose() {
    cancelProcessing();
    super.onClose();
  }
}
