import 'package:appear_ai_image_editor/data/services/subscription_service.dart';
import 'package:appear_ai_image_editor/presentation/widgets/snack_bar_message.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImageProcessingSettingsController extends GetxController {
  bool _comparisonMode = false;
  bool _transparentMode = false;
  double _scale = 2.0;  // Default scale value
  bool _hasShownSubscriptionMessage = false;
  bool _hasShownVipMessage = false;

  final SubscriptionService _subscriptionService = SubscriptionService.to;

  bool get comparisonMode => _comparisonMode;
  bool get transparentMode => _transparentMode;
  double get scale => _scale;

  void toggleComparisonMode(bool value) {
    _comparisonMode = value;
    update();
  }

  void toggleTransparentMode(bool value) {
    _transparentMode = value;
    update();
  }

  void updateScale(double value) {
    // Check subscription status before allowing scale update
    if (value > 3.0 && !_subscriptionService.isVip()) {
      if (!_hasShownVipMessage) {
        showSnackBarMessage(
          title: 'VIP Required',
          message: '4x enhancement is only available for VIP members. Upgrade to VIP to access this feature!',
          colorText: Colors.white,
        );
        _hasShownVipMessage = true;
      }
      return;
    }

    if (value > 2.0 && !_subscriptionService.hasSubscription()) {
      if (!_hasShownSubscriptionMessage) {
        showSnackBarMessage(
          title: 'Subscription Required',
          message: '3x require a subscription. Subscribe to access enhanced features!',
          colorText: Colors.white,
        );
        _hasShownSubscriptionMessage = true;
      }
      return;
    }

    _scale = value;
    update();
  }

  // Helper method to get available scale values based on subscription
  List<double> getAvailableScales() {
    if (_subscriptionService.isVip()) {
      return [2.0, 3.0, 4.0];  // VIP gets all scales
    } else if (_subscriptionService.hasSubscription()) {
      return [2.0, 3.0];  // Subscribers get up to 3x
    }
    return [2.0];  // Free users only get 2x
  }

  // Method to validate current scale against subscription
  void validateCurrentScale() {
    if (_scale > 3.0 && !_subscriptionService.isVip()) {
      _scale = 3.0;
      update();
    } else if (_scale > 2.0 && !_subscriptionService.hasSubscription()) {
      _scale = 2.0;
      update();
    }
  }
}
