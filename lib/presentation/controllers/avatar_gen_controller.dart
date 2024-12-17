import 'package:get/get.dart';
import 'package:image_ai_editor/data/models/avatar_gen_model.dart';
import 'package:image_ai_editor/data/services/avatar_gen_service.dart';
import 'package:image_ai_editor/data/services/image_storage_service.dart';
import 'package:image_ai_editor/data/utility/urls.dart';
import 'package:image_ai_editor/presentation/controllers/fetch_queued_image_controller.dart';
import 'package:image_ai_editor/presentation/controllers/polling_result_controller.dart';
import 'package:image_ai_editor/presentation/controllers/processing_controller.dart';
import 'package:image_ai_editor/processing_type.dart';

class AvatarGenController extends ProcessingController with PollingResultMixin {
  final AvatarGenService _avatarService = AvatarGenService();
  final ImageStorageService _storageService = Get.find();
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

    return await generateAvatar(_currentInitImage!, _currentPrompt!);
  }

  Future<bool> generateAvatar(String initImage, String prompt) async {
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
        processingType: ProcessingType.avatarGen.storageKey,
      );

      if (storedData != null && storedData['processedUrl']?.isNotEmpty == true) {
        updateState(
          resultImageUrl: storedData['processedUrl']!,
          inProgress: false,
        );
        return true;
      }

      AvatarGenModel model = AvatarGenModel(
        apiKey: Urls.api_Key,
        initImage: initImage,
        prompt: prompt,
      );

      Map<String, dynamic> response = await _avatarService.generateAvatar(model);
      print('Avatar Generation Response: $response');

      if (response.containsKey('output') && response['output'] != null) {
        updateState(
          resultImageUrl: response['output'],
          generationTime: response['generationTime'] ?? 0.0,
          inProgress: false,
        );

        _storageService.storeImageData(
          base64Image: initImage,
          processedUrl: resultImageUrl,
          processingType: ProcessingType.avatarGen.storageKey,
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
        errorMessage: 'Error in generateAvatar: $e',
        inProgress: false,
      );
      print('Avatar Generation Error: $errorMessage');
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
    _currentPrompt = null;
  }
}