import 'package:get/get.dart';
import 'package:appear_ai_image_editor/processing_type.dart';

class ImageLoadController extends GetxController {
  bool _isLoading = true;
  bool _hasError = false;
  int _retryCount = 0;
  static const int maxRetries = 3;
  String _currentUrl = '';

  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  int get retryCount => _retryCount;

  void startLoading(String url) {
    if (_currentUrl != url) {
      _currentUrl = url;
      _isLoading = true;
      _hasError = false;
      _retryCount = 0;
      update();
    }
  }

  void setLoadingComplete() {
    _isLoading = false;
    _hasError = false;
    _retryCount = 0;
    update();
  }

  void handleError() {
    _hasError = true;
    _isLoading = false;
    _retryCount++;
    update();
  }

  bool shouldRetry(ProcessingType processingType) {
    return processingType == ProcessingType.imageEnhancement && _retryCount < maxRetries;
  }

  void reset() {
    _isLoading = true;
    _hasError = false;
    _retryCount = 0;
    _currentUrl = '';
    update();
  }
}