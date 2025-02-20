import 'package:appear_ai_image_editor/presentation/controllers/result_preview/result_controller_polling.dart';
import 'package:get/get.dart';

abstract class ProcessingController extends GetxController {
  bool _inProgress = false;
  String _errorMessage = '';
  String _resultImageUrl = '';
  String _trackedId = '';
  double _generationTime = 0.0;

  // Getters
  bool get inProgress => _inProgress;
  String get errorMessage => _errorMessage;
  String get resultImageUrl => _resultImageUrl;
  String get trackedId => _trackedId;
  double get generationTime => _generationTime;

  // Abstract method to be implemented by child classes
  Future<bool> processImage(String base64Image);

  // Common method to clear process
  void clearCurrentProcess() {
    updateState(
      resultImageUrl: '',
      trackedId: '',
      errorMessage: '',
      inProgress: false,
    );
  }

  // Add cancel method to be called in onClose
  void cancelProcessing() {
    if (this is PollingResultMixin) {
      (this as PollingResultMixin).cancelPolling();
      (this as PollingResultMixin).markAsDisposed();
    }
    clearCurrentProcess();
  }

  // Override onClose to ensure cancellation
  @override
  void onClose() {
    cancelProcessing();
    super.onClose();
  }

  // Helper method to update state
  void updateState({
    bool? inProgress,
    String? errorMessage,
    String? resultImageUrl,
    String? trackedId,
    double? generationTime,
  }) {
    // Only update state if not disposed
    if (!isClosed) {
      _inProgress = inProgress ?? _inProgress;
      _errorMessage = errorMessage ?? _errorMessage;
      _resultImageUrl = resultImageUrl ?? _resultImageUrl;
      _trackedId = trackedId ?? _trackedId;
      _generationTime = generationTime ?? _generationTime;
      update();
    }
  }
}
