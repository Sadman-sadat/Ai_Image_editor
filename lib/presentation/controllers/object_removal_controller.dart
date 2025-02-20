import 'package:get/get.dart';
import 'package:appear_ai_image_editor/data/models/object_removal_model.dart';
import 'package:appear_ai_image_editor/data/services/object_removal_service.dart';
import 'package:appear_ai_image_editor/data/utility/urls.dart';
import 'package:appear_ai_image_editor/presentation/controllers/fetch_queued_image_controller.dart';
import 'package:appear_ai_image_editor/presentation/controllers/polling_result_controller.dart';
import 'package:appear_ai_image_editor/presentation/controllers/processing_controller.dart';
import 'package:appear_ai_image_editor/processing_type.dart';

class ObjectRemovalController extends ProcessingController with PollingResultMixin {
  final ObjectRemovalService _objectRemovalService = ObjectRemovalService();
  final FetchQueuedImageController _fetchController = Get.find();

  String? _currentMask;
  String? _currentImage;

  void setMask(String maskBase64) {
    _currentMask = maskBase64;
  }

  void setImage(String imageBase64) {
    _currentImage = imageBase64;
  }

  @override
  Future<bool> processImage(String base64Image) async {
    if (_currentMask == null) {
      updateState(
          errorMessage: 'No mask provided for object removal',
          inProgress: false
      );
      return false;
    }

    return await removeObject(base64Image, _currentMask!);
  }

  Future<bool> removeObject(String base64Original, String base64Mask) async {
    bool isSuccess = false;
    _objectRemovalService.resetCancellation();

    updateState(
      inProgress: true,
      errorMessage: '',
      resultImageUrl: '',
      trackedId: '',
    );

    try {
      ObjectRemovalModel model = ObjectRemovalModel(
        apiKey: Urls.api_Key,
        initImage: base64Original,
        maskImage: base64Mask,
      );

      Map response = await _objectRemovalService.removeObject(model);
      print('Object Removal Response: $response');

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
        errorMessage: 'Error in removeObject: $e',
        inProgress: false,
      );
      print('Object Removal Error: $errorMessage');
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
    _currentMask = null;
    _currentImage = null;
    _objectRemovalService.cancelRequest();
  }

  @override
  void cancelProcessing() {
    _objectRemovalService.cancelRequest();
    _objectRemovalService.markAsDisposed();
    super.cancelProcessing();
    clearCurrentProcess();
  }

  @override
  void onClose() {
    cancelProcessing();
    super.onClose();
  }
}
