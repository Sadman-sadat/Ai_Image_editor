import 'package:appear_ai_image_editor/data/services/payment_handler.dart';
import 'package:appear_ai_image_editor/data/services/subscription_service.dart';
import 'package:appear_ai_image_editor/presentation/controllers/ads/ad_controller.dart';
import 'package:appear_ai_image_editor/presentation/widgets/snack_bar_message.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class SubscriptionController extends GetxController {
  bool isLoading = true;
  List<ProductDetails> products = [];
  String? errorMessage;
  late PaymentHandler _paymentHandler;
  final AdController _adController = Get.find<AdController>();
  DateTime? _lastTapTime;
  bool _isInitialized = false;
  String _currentStatus = 'Free User';
  Color _statusColor = Colors.grey;

  String get currentStatus => _currentStatus;
  Color get statusColor => _statusColor;

  @override
  void onInit() {
    super.onInit();
    _initialize();
    _updateSubscriptionStatus();
  }

  Future<void> _initialize() async {
    if (_isInitialized) return;

    try {
      _initPaymentHandler();
      isLoading = false;
      _isInitialized = true;
      update();
    } catch (e) {
      errorMessage = 'Initialization error: $e';
      isLoading = false;
      update();
    }
  }

  void _initPaymentHandler() {
    _paymentHandler = PaymentHandler(
      onLoading: (loading) {
        isLoading = loading;
        update();
      },
      onProductsLoaded: (loadedProducts) {
        products = loadedProducts;
        update();
      },
      onError: (error) {
        errorMessage = error;
        update();
      },
      onPurchaseSuccess: (purchaseDetails) async {
        try {
          await SubscriptionService.to.activateSubscription(purchaseDetails);
          if (!SubscriptionService.to.shouldShowAds()) {
            _adController.disableAds();
          }
          _updateSubscriptionStatus();
          _showSuccessMessage(purchaseDetails.productID);
          update();
        } catch (e) {
          errorMessage = 'Error activating subscription: $e';
          update();
        }
      },
      subscriptionService: SubscriptionService.to,
    );

    _paymentHandler.init();
  }

  Future<void> buySubscription(String planId) async {
    final now = DateTime.now();
    if (_lastTapTime != null && now.difference(_lastTapTime!) < const Duration(seconds: 2)) {
      return;
    }
    _lastTapTime = now;

    try {
      final productIndex = products.indexWhere((p) => p.id == planId);
      if (productIndex == -1) {
        showSnackBarMessage(
          title: 'Product Not Available',
          message: 'This subscription plan is currently not available.',
        );
        return;
      }

      _paymentHandler.buySubscription(products[productIndex]);
    } catch (e) {
      showSnackBarMessage(
        title: 'Error',
        message: 'An error occurred while processing your subscription.',
      );
      errorMessage = e.toString();
      update();
    }
  }

  void _updateSubscriptionStatus() {
    final currentPlan = SubscriptionService.to.getCurrentPlan();

    if (SubscriptionService.to.isVip()) {
      _currentStatus = 'Status: VIP';
      _statusColor = Colors.orange;
    } else if (SubscriptionService.to.hasSubscription() && currentPlan != null) {
      _currentStatus = 'Status: ${currentPlan[0].toUpperCase()}${currentPlan.substring(1)}';
      _statusColor = Colors.green;
    } else {
      _currentStatus = 'Status: Free';
      _statusColor = Colors.grey;
    }
    update();
  }

  void _showSuccessMessage(String planId) {
    final planName = planId == 'vip'
        ? 'VIP'
        : '${planId[0].toUpperCase()}${planId.substring(1)}';

    showSnackBarMessage(
      title: 'Success',
      message: '$planName plan activated!',
      colorText: Colors.white,
    );
  }

  String? getSubscriptionStatus() {
    return _currentStatus;
  }

  String getPrice(String planId) {
    if (isLoading) return 'Loading...';
    if (products.isEmpty) return 'N/A';

    final product = products.firstWhereOrNull((p) => p.id == planId);
    return product?.price ?? 'N/A';
  }

  @override
  void onClose() {
    _paymentHandler.dispose();
    _isInitialized = false;
    super.onClose();
  }
}