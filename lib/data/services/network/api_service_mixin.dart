import 'dart:async';
import 'package:appear_ai_image_editor/data/services/network/network_caller.dart';

mixin ApiServiceMixin {
  final NetworkCaller _networkCaller = NetworkCaller();
  static const int maxRetries = 5;  // Reduced from 5
  static const int baseDelay = 500; // Reduced from 1000
  static const int maxDelayBetweenRetries = 5000; // Maximum 5 seconds between retries

  bool _isCancelled = false;
  bool _isDisposed = false;

  Future<Map<String, dynamic>> makeApiRequest({
    required String endpoint,
    required Map<String, dynamic> requestData,
    int currentRetry = 0,
  }) async {
    if (_isCancelled || _isDisposed) {
      throw 'Request cancelled';
    }

    try {
      final responseData = await _networkCaller.postRequest(
        endpoint,
        requestData,
      );

      if (_isCancelled || _isDisposed) {
        throw 'Request cancelled';
      }

      if (responseData['status'] == 'success') {
        return {
          'output': responseData['output']?[0],
          'id': responseData['id'],
          'generationTime': responseData['generationTime'],
          'status': 'success',
        };
      } else if (responseData['status'] == 'processing') {
        // Add timeout for processing status
        final processingTimeout = Timer(const Duration(seconds: 210), () {
          if (!_isCancelled) {
            cancelRequest();
            throw 'Processing timeout: Please try again';
          }
        });

        return {
          'id': responseData['id'],
          'generationTime': responseData['generationTime'],
          'status': 'processing',
        };
      } else {
        throw responseData['message'] ?? 'Unknown error';
      }
    } catch (e) {
      if (_isCancelled || _isDisposed) {
        throw 'Request cancelled';
      }

      if (currentRetry < maxRetries) {
        final delay = calculateBackoff(currentRetry);

        try {
          await Future.delayed(Duration(milliseconds: delay));

          if (_isCancelled || _isDisposed) {
            throw 'Request cancelled';
          }
        } catch (e) {
          if (_isCancelled || _isDisposed) {
            throw 'Request cancelled';
          }
          rethrow;
        }

        return makeApiRequest(
          endpoint: endpoint,
          requestData: requestData,
          currentRetry: currentRetry + 1,
        );
      }
      throw e.toString();
    }
  }

  int calculateBackoff(int retryCount) {
    final delay = baseDelay * (1 << retryCount);
    return delay.clamp(0, maxDelayBetweenRetries);
  }

  void cancelRequest() {
    _isCancelled = true;
    print('API request cancelled');
  }

  void markAsDisposed() {
    _isDisposed = true;
    print('API request marked as disposed');
  }

  void resetCancellation() {
    _isCancelled = false;
    _isDisposed = false;
  }
}
