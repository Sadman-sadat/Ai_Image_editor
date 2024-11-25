import 'dart:math';
import 'package:get/get.dart';
import 'package:image_ai_editor/data/models/fetch_queued_image_model.dart';
import 'package:image_ai_editor/data/services/fetch_queued_image_service.dart';
import 'package:image_ai_editor/data/services/image_storage_service.dart';
import 'package:image_ai_editor/data/utility/urls.dart';

class FetchQueuedImageController extends GetxController {
  final FetchQueuedImageService _fetchQueuedImageService = FetchQueuedImageService();
  final ImageStorageService _storageService = Get.find<ImageStorageService>();

  final RxString fetchedImageUrl = ''.obs;
  final RxBool isLoading = false.obs;

  // Cache for tracking recent fetch attempts
  final Map<String, DateTime> _lastFetchAttempts = {};
  static const Duration _minFetchInterval = Duration(seconds: 3);

  // Maximum number of retry attempts
  static const int _maxRetries = 5;
  int _currentRetries = 0;

  Future<void> fetchQueuedImage(
      String trackerId, {
        String? base64Image,
        String? processingType,
      }) async {
    if (trackerId.isEmpty) {
      print('Cannot fetch image: trackerId is empty');
      return;
    }

    // Check storage for previously processed image
    if (base64Image != null) {
      final storedData = _storageService.getImageData(
        base64Image: base64Image,
        processingType: processingType,
      );
      if (storedData != null && storedData['processedUrl']?.isNotEmpty == true) {
        fetchedImageUrl.value = storedData['processedUrl']!;
        return;
      }
    }

    isLoading.value = true;
    _lastFetchAttempts[trackerId] = DateTime.now();

    try {
      final fetchQueuedImageModel = FetchQueuedImageModel(
        apiKey: Urls.api_Key,
      );

      final fetchedUrl = await _fetchQueuedImageService.fetchQueuedImage(
        trackerId,
        fetchQueuedImageModel,
      );

      if (fetchedUrl != null && fetchedUrl.isNotEmpty) {
        fetchedImageUrl.value = fetchedUrl;
        _currentRetries = 0; // Reset retry counter on success

        // Store the fetched URL if base64Image and processingType are provided
        if (base64Image != null && processingType != null) {
          _storageService.storeImageData(
            base64Image: base64Image,
            processedUrl: fetchedUrl,
            processingType: processingType,
          );
        }
      } else {
        _handleEmptyResponse(trackerId, base64Image: base64Image, processingType: processingType);
      }
    } catch (error, stackTrace) {
      print('Error fetching queued image: $error');
      print('Stack trace: $stackTrace');
      _handleError(trackerId, base64Image: base64Image, processingType: processingType);
    } finally {
      isLoading.value = false;
    }
  }

  bool _shouldThrottle(String trackerId) {
    final lastAttempt = _lastFetchAttempts[trackerId];
    if (lastAttempt == null) return false;

    final timeSinceLastAttempt = DateTime.now().difference(lastAttempt);
    return timeSinceLastAttempt < _minFetchInterval;
  }

  void _handleEmptyResponse(
      String trackerId, {
        String? base64Image,
        String? processingType,
      }) {
    if (_currentRetries < _maxRetries) {
      _currentRetries++;
      // Exponential backoff for retry delay
      final delay = Duration(seconds: pow(2, _currentRetries).toInt());
      Future.delayed(
        delay,
            () => fetchQueuedImage(
          trackerId,
          base64Image: base64Image,
          processingType: processingType,
        ),
      );
    } else {
      _currentRetries = 0;
      fetchedImageUrl.value = '';
    }
  }

  void _handleError(
      String trackerId, {
        String? base64Image,
        String? processingType,
      }) {
    fetchedImageUrl.value = '';

    // Check storage for previously processed URL
    if (base64Image != null && processingType != null) {
      final storedData = _storageService.getImageData(
        base64Image: base64Image,
        processingType: processingType,
      );
      if (storedData != null && storedData['processedUrl']?.isNotEmpty == true) {
        fetchedImageUrl.value = storedData['processedUrl']!;
      }
    }
  }

  // Clear the fetched image URL
  void clearFetchedImageUrl() {
    fetchedImageUrl.value = '';
  }
}
