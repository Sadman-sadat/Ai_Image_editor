import 'package:appear_ai_image_editor/data/services/subscription_service.dart';
import 'package:appear_ai_image_editor/data/utility/product_ids.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'dart:async';

class PaymentHandler {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  final SubscriptionService _subscriptionService;

  final Function(bool) onLoading;
  final Function(List<ProductDetails>) onProductsLoaded;
  final Function(String) onError;
  final Function(PurchaseDetails) onPurchaseSuccess;

  PaymentHandler({
    required this.onLoading,
    required this.onProductsLoaded,
    required this.onError,
    required this.onPurchaseSuccess,
    required SubscriptionService subscriptionService,
  }) : _subscriptionService = subscriptionService;

  Future<void> init() async {
    try {
      final Stream<List<PurchaseDetails>> purchaseUpdated =
          _inAppPurchase.purchaseStream;

      _subscription = purchaseUpdated.listen(
        _onPurchaseUpdate,
        onDone: () => _subscription.cancel(),
        onError: (error) => onError(error.toString()),
      );

      final bool available = await _inAppPurchase.isAvailable();
      if (!available) {
        onLoading(false);
        onError('Store not available');
        return;
      }

      await _loadProducts();
    } catch (e) {
      print('Initialization error: $e');
      onError('Failed to initialize payment system: $e');
      onLoading(false);
    }
  }

  Future<void> _loadProducts() async {
    try {
      final ProductDetailsResponse response =
      await _inAppPurchase.queryProductDetails(ProductIds.allProductIds);

      if (response.error != null) {
        onError(response.error!.message);
        return;
      }

      if (response.productDetails.isEmpty) {
        onError('No products found');
        return;
      }

      onProductsLoaded(response.productDetails);
      onLoading(false);
    } catch (e) {
      onError('Error loading products: $e');
      onLoading(false);
    }
  }

  Future<void> buySubscription(ProductDetails productDetails) async {
    try {
      final status = await _subscriptionService.getSubscriptionStatus();

      // Handle upgrade/downgrade scenario
      if (status.isActive && !status.isVip) {
        await _handleSubscriptionChange(productDetails);
        return;
      }

      final PurchaseParam purchaseParam = PurchaseParam(
        productDetails: productDetails,
      );

      if (productDetails.id == ProductIds.vip) {
        await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
      } else {
        await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
      }
    } catch (e) {
      onError('Error making purchase: $e');
    }
  }

  Future<void> _handleSubscriptionChange(ProductDetails newProduct) async {
    // Implement upgrade/downgrade logic here
    // You might want to show a confirmation dialog to the user
    final PurchaseParam purchaseParam = PurchaseParam(
      productDetails: newProduct,
    );

    await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
  }

  Future<void> _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      try {
        switch (purchaseDetails.status) {
          case PurchaseStatus.pending:
            onLoading(true);
            break;

          case PurchaseStatus.purchased:
          case PurchaseStatus.restored:
            await _handleSuccessfulPurchase(purchaseDetails);
            break;

          case PurchaseStatus.error:
            _handlePurchaseError(purchaseDetails);
            break;

          default:
            break;
        }
      } catch (e) {
        print('Error processing purchase update: $e');
        onError('Failed to process purchase: $e');
      }
    }
  }

  Future<void> _handleSuccessfulPurchase(PurchaseDetails purchase) async {
    try {
      if (purchase.pendingCompletePurchase) {
        await _inAppPurchase.completePurchase(purchase);
      }

      await _subscriptionService.activateSubscription(purchase);
      onPurchaseSuccess(purchase);
      onLoading(false);
    } catch (e) {
      onError('Error activating purchase: $e');
      onLoading(false);
    }
  }

  void _handlePurchaseError(PurchaseDetails purchase) {
    print('Purchase error: ${purchase.error}');
    onError(purchase.error?.message ?? 'Purchase error');
    onLoading(false);
  }

  void dispose() {
    _subscription.cancel();
  }
}
