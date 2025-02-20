import 'package:get/get.dart';

class ProcessingTextController extends GetxController {
  int _currentStep = 0;
  String _dots = '';
  final List<String> steps;

  ProcessingTextController(this.steps);

  int get currentStep => _currentStep;
  String get dots => _dots;

  @override
  void onInit() {
    super.onInit();
    _startTimers();
  }

  void _startTimers() {
    // Dots animation
    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 500));
      _dots = _dots.length >= 3 ? '' : '$_dots.';
      update();
      return true;
    });

    // Steps progression
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 6));
      _currentStep = _currentStep >= (steps.length - 1) ? 0 : _currentStep + 1;
      update();
      return true;
    });
  }
}