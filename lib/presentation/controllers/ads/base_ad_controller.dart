import 'package:get/get.dart';
import 'package:appear_ai_image_editor/data/services/subscription_service.dart';

abstract class BaseAdController extends GetxController {
  // Retry configuration
  static const int maxRetries = 3;
  static const List<int> retryIntervals = [5, 15, 30]; // seconds

  int retryAttempt = 0;
  DateTime? loadTime;
  bool isLoaded = false;
  bool isPreloading = false;

  late SubscriptionService _subscriptionService;
  bool _isInitialized = false;

  @override
  void onInit() async {
    super.onInit();
    await _initSubscriptionService();
  }

  Future<void> _initSubscriptionService() async {
    _subscriptionService = Get.find<SubscriptionService>();
    _isInitialized = true;
  }

  Future<bool> shouldShowAds() async {
    //same as ad controller
    // if (!_isInitialized) {
    //   await _initSubscriptionService();
    // }
    return _subscriptionService.shouldShowAds();
  }

  void resetRetryAttempt() {
    retryAttempt = 0;
  }

  bool canRetry() {
    return retryAttempt < maxRetries;
  }

  int getRetryDelay() {
    return retryIntervals[retryAttempt];
  }

  void incrementRetryAttempt() {
    if (retryAttempt < maxRetries) {
      retryAttempt++;
    }
  }

  @override
  void dispose();
}
