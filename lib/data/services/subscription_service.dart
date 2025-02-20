import 'dart:async';
import 'package:appear_ai_image_editor/data/models/subscription_status_model.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class SubscriptionService {
  bool _isVip = false;
  bool _isSubscribed = false;
  String? _currentPlan;
  String? _purchaseToken;

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  bool _isRestoring = false;

  SubscriptionService();
  static SubscriptionService get to => Get.find<SubscriptionService>();

  static Future<SubscriptionService> init() async {
    if (Get.isRegistered<SubscriptionService>()) {
      return Get.find<SubscriptionService>();
    }

    final service = SubscriptionService();
    await service.checkSubscriptionOnLaunch();

    Get.put(service, permanent: true);
    return service;
  }

  Future<void> checkSubscriptionOnLaunch() async {
    if (_isRestoring) return;
    _isRestoring = true;

    try {
      final bool available = await _inAppPurchase.isAvailable();
      if (!available) {
        _isRestoring = false;
        return;
      }

      StreamSubscription? subscription;
      subscription = _inAppPurchase.purchaseStream.listen(
            (purchaseDetailsList) async {
          for (var purchaseDetails in purchaseDetailsList) {
            if (purchaseDetails.status == PurchaseStatus.restored ||
                purchaseDetails.status == PurchaseStatus.purchased) {
              await _handleRestoredPurchase(purchaseDetails);
            }
          }
        },
        onDone: () {
          subscription?.cancel();
          _isRestoring = false;
        },
        onError: (error) {
          print('Error restoring purchases: $error');
          subscription?.cancel();
          _isRestoring = false;
        },
      );

      await _inAppPurchase.restorePurchases();
      await Future.delayed(const Duration(seconds: 3));
      subscription.cancel();
    } catch (e) {
      print('Error during launch check: $e');
    } finally {
      _isRestoring = false;
    }
  }

  Future<void> _handleRestoredPurchase(PurchaseDetails purchase) async {
    await activateSubscription(purchase);
  }

  Future<SubscriptionStatusModel> getSubscriptionStatus() async {
    return SubscriptionStatusModel(
      isActive: _isVip || _isSubscribed,
      isVip: _isVip,
      planId: _isVip ? 'vip' : (_isSubscribed ? 'subscription' : null),
    );
  }

  Future<void> activateSubscription(PurchaseDetails purchase) async {
    if (purchase.productID == 'vip') {
      _isVip = true;
      _currentPlan = 'vip';
    } else {
      _isSubscribed = true;
      _currentPlan = purchase.productID;
    }
    _purchaseToken = purchase.purchaseID;
  }

  bool hasSubscription() {
    return _isVip || _isSubscribed;
  }

  bool shouldShowAds() {
    return !(_isVip || _isSubscribed);
  }

  bool isVip() {
    return _isVip;
  }

  String? getCurrentPlan() {
    return _currentPlan;
  }

  void clearSubscription() {
    _isVip = false;
    _isSubscribed = false;
    _currentPlan = null;
    _purchaseToken = null;
  }
}
