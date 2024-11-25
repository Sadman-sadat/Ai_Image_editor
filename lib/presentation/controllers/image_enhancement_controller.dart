import 'package:get/get.dart';
import 'package:image_ai_editor/data/models/image_enhancement_model.dart';
import 'package:image_ai_editor/data/services/image_enhancement_service.dart';
import 'package:image_ai_editor/data/services/image_storage_service.dart';
import 'package:image_ai_editor/data/utility/urls.dart';
import 'package:image_ai_editor/presentation/controllers/fetch_queued_image_controller.dart';
import 'package:image_ai_editor/processing_type.dart';

class ImageEnhancementController extends GetxController {
  final ImageEnhancementService _imageEnhancementService = ImageEnhancementService();
  final ImageStorageService _storageService = Get.find<ImageStorageService>();
  final FetchQueuedImageController _fetchController = Get.find<FetchQueuedImageController>();

  RxBool isLoading = false.obs;
  RxString resultImageUrl = ''.obs;
  RxString trackedId = ''.obs;
  RxDouble generationTime = 0.0.obs;

  Future<void> enhanceImage(String base64Image) async {
    isLoading.value = true;
    resultImageUrl.value = '';
    trackedId.value = '';

    try {
      // Check if we already have this processed image
      final storedData = _storageService.getImageData(
        base64Image: base64Image,
        processingType: ProcessingType.imageEnhancement.storageKey,
      );
      if (storedData != null && storedData['processedUrl']?.isNotEmpty == true) {
        resultImageUrl.value = storedData['processedUrl']!;
        isLoading.value = false;
        return;
      }

      ImageEnhancementModel model = ImageEnhancementModel(
        apiKey: Urls.api_Key,
        image: base64Image,
      );

      Map<String, dynamic> response = await _imageEnhancementService.enhancementImage(model);

      if (response.containsKey('output') && response['output'] != null) {
        resultImageUrl.value = response['output'];
        generationTime.value = response['generationTime'] ?? 0.0;

        // Store the processed image
        _storageService.storeImageData(
            base64Image: base64Image,
            processedUrl: resultImageUrl.value,
            processingType: ProcessingType.imageEnhancement.storageKey,
        );
      } else if (response.containsKey('id')) {
        trackedId.value = response['id'].toString();
        generationTime.value = response['generationTime'] ?? 0.0;

        // Start polling with base64Image and processing type
        _startPollingForResult(base64Image);
      }
    } catch (e, stackTrace) {
      print('Error in enhanceImage: $e');
      print('Stack trace: $stackTrace');
    } finally {
      isLoading.value = false;
    }
  }

  void _startPollingForResult(String base64Image) {
    if (trackedId.isEmpty) return;

    Future.doWhile(() async {
      if (_fetchController.fetchedImageUrl.isNotEmpty) {
        resultImageUrl.value = _fetchController.fetchedImageUrl.value;
        return false;
      }

      await _fetchController.fetchQueuedImage(
        trackedId.value,
        base64Image: base64Image,
        processingType: ProcessingType.imageEnhancement.storageKey,
      );

      await Future.delayed(const Duration(seconds: 5));
      return _fetchController.fetchedImageUrl.isEmpty && !_fetchController.isLoading.value;
    });
  }

  // Clear the current processing data
  void clearCurrentProcess() {
    resultImageUrl.value = '';
    trackedId.value = '';
    _fetchController.clearFetchedImageUrl();
  }
}

