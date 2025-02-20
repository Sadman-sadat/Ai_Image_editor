import 'package:get/get.dart';
import 'package:appear_ai_image_editor/presentation/controllers/fetch_queued_image_controller.dart';
import 'package:appear_ai_image_editor/presentation/controllers/result_preview/result_controller_processing_controller.dart';

mixin PollingResultMixin {
  bool _isPollingCancelled = false;
  bool _isDisposed = false;

  Future<void> startPollingForResult({
    required ProcessingController controller,
    required String trackerId,
    int maxAttempts = 20,
  }) async {
    print('Starting polling for trackerId: $trackerId');
    _isPollingCancelled = false;
    _isDisposed = false;

    int attempts = 0;
    bool imageFound = false;

    final fetchController = Get.find<FetchQueuedImageController>();

    while (attempts < maxAttempts && !imageFound && !_isPollingCancelled && !_isDisposed) {
      print('Polling attempt $attempts');

      bool fetchResult = await fetchController.fetchQueuedImage(trackerId);

      // Check if polling was cancelled or disposed during the fetch operation
      if (_isPollingCancelled || _isDisposed) {
        print('Polling cancelled or disposed during fetch operation');
        break;
      }

      print('Fetch attempt result: $fetchResult');
      print('Fetched Image URL: ${fetchController.fetchedImageUrl}');

      if (fetchController.fetchedImageUrl.isNotEmpty) {
        if (!_isDisposed && !_isPollingCancelled) {
          controller.updateState(
            resultImageUrl: fetchController.fetchedImageUrl,
            inProgress: false,
          );
        }
        imageFound = true;
        break;
      }

      // Check if polling was cancelled or disposed before delay
      if (_isPollingCancelled || _isDisposed) {
        print('Polling cancelled or disposed before delay');
        break;
      }

      // Exponential backoff
      await Future.delayed(Duration(seconds: 3 * (attempts + 1)));
      attempts++;
    }

    if (!imageFound && !_isPollingCancelled && !_isDisposed) {
      controller.updateState(
        errorMessage: 'Could not retrieve processed image after $maxAttempts attempts',
        inProgress: false,
      );
      print('Failed to retrieve image after multiple attempts');
    }
  }

  void cancelPolling() {
    _isPollingCancelled = true;
    print('Polling cancelled');
  }

  void markAsDisposed() {
    _isDisposed = true;
    print('Polling marked as disposed');
  }
}
