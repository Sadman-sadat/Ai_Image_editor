import 'package:get/get.dart';
import 'package:image_ai_editor/presentation/controllers/fetch_queued_image_controller.dart';
import 'package:image_ai_editor/presentation/controllers/processing_controller.dart';
import 'package:image_ai_editor/processing_type.dart';

mixin PollingResultMixin {
  Future<void> startPollingForResult({
    required ProcessingController controller,
    required String base64Image,
    required String trackerId,
    required ProcessingType processingType,
    int maxAttempts = 20,
  }) async {
    print('Starting polling for trackerId: $trackerId');

    int attempts = 0;
    bool imageFound = false;

    final fetchController = Get.find<FetchQueuedImageController>();

    while (attempts < maxAttempts && !imageFound) {
      print('Polling attempt $attempts');

      bool fetchResult = await fetchController.fetchQueuedImage(
        trackerId,
        base64Image: base64Image,
        processingType: processingType.storageKey,
      );

      print('Fetch attempt result: $fetchResult');
      print('Fetched Image URL: ${fetchController.fetchedImageUrl}');

      if (fetchController.fetchedImageUrl.isNotEmpty) {
        controller.updateState(
          resultImageUrl: fetchController.fetchedImageUrl,
          inProgress: false,
        );
        imageFound = true;
        break;
      }

      // Exponential backoff
      await Future.delayed(Duration(seconds: 3 * (attempts + 1)));
      attempts++;
    }

    if (!imageFound) {
      controller.updateState(
        errorMessage: 'Could not retrieve processed image after $maxAttempts attempts',
        inProgress: false,
      );
      print('Failed to retrieve image after multiple attempts');
    }
  }
}