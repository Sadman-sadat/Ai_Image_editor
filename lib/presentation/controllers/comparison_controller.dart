import 'package:get/get.dart';

class ComparisonController extends GetxController {
  double _dividerPosition = 0.5;
  bool _isComparisonMode = false;

  double get dividerPosition => _dividerPosition;
  bool get isComparisonMode => _isComparisonMode;

  void toggleComparisonMode() {
    _isComparisonMode = !_isComparisonMode;
    _dividerPosition = 0.5;
    update(); // Notify GetBuilder to rebuild
  }

  void updateDividerPosition(double newPosition) {
    if (newPosition >= 0.05 && newPosition <= 0.95) {
      _dividerPosition = newPosition;
      update(); // Notify GetBuilder to rebuild
    }
  }
}