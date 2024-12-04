import 'package:get/get.dart';
import 'package:image_ai_editor/data/models/fetch_queued_image_model.dart';
import 'package:image_ai_editor/data/services/fetch_queued_image_service.dart';
import 'package:image_ai_editor/data/services/image_storage_service.dart';
import 'package:image_ai_editor/data/utility/urls.dart';

class FetchQueuedImageController extends GetxController {
  bool _inProgress = false;
  String _errorMessage = '';
  String _fetchedImageUrl = '';

  final FetchQueuedImageService _fetchQueuedImageService = FetchQueuedImageService();
  final ImageStorageService _storageService = Get.find<ImageStorageService>();

  bool get inProgress => _inProgress;
  String get errorMessage => _errorMessage;
  String get fetchedImageUrl => _fetchedImageUrl;

  Future<bool> fetchQueuedImage(
      String trackerId, {
        String? base64Image,
        String? processingType,
      }) async {
    bool isSuccess = false;
    _inProgress = true;
    _errorMessage = '';
    _fetchedImageUrl = '';
    update();

    if (trackerId.isEmpty) {
      _errorMessage = 'Cannot fetch image: trackerId is empty';
      print(_errorMessage);
      _inProgress = false;
      update();
      return false;
    }

    // Check storage for previously processed image
    if (base64Image != null && processingType != null) {
      final storedData = _storageService.getImageData(
        base64Image: base64Image,
        processingType: processingType,
      );

      if (storedData != null && storedData['processedUrl']?.isNotEmpty == true) {
        _fetchedImageUrl = storedData['processedUrl']!;
        isSuccess = true;
        _inProgress = false;
        update();
        return isSuccess;
      }
    }

    try {
      final fetchQueuedImageModel = FetchQueuedImageModel(
        apiKey: Urls.api_Key,
      );

      final fetchedUrl = await _fetchQueuedImageService.fetchQueuedImage(
        trackerId,
        fetchQueuedImageModel,
      );

      if (fetchedUrl != null && fetchedUrl.isNotEmpty) {
        _fetchedImageUrl = fetchedUrl;
        isSuccess = true;

        // Store the fetched URL if base64Image and processingType are provided
        if (base64Image != null && processingType != null) {
          _storageService.storeImageData(
            base64Image: base64Image,
            processedUrl: fetchedUrl,
            processingType: processingType,
          );
        }
      } else {
        _errorMessage = 'No image found for tracker ID';
      }
    } catch (error, stackTrace) {
      _errorMessage = 'Error fetching queued image: $error';
      print(_errorMessage);
      print('Stack trace: $stackTrace');
    } finally {
      _inProgress = false;
      update();
    }

    return isSuccess;
  }

  void clearFetchedImageUrl() {
    _fetchedImageUrl = '';
    _errorMessage = '';
    update();
  }
}
