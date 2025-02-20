class ProductIds {
  static const String basic = 'basic';
  static const String standard = 'standard';
  static const String advanced = 'advanced';
  static const String vip = 'vip';

  static const Map<String, Duration> subscriptionDurations = {
    basic: Duration(days: 7),
    standard: Duration(days: 30),
    advanced: Duration(days: 90),
  };

  static Set<String> get subscriptionIds => {
    basic,
    standard,
    advanced,
  };

  static Set<String> get inAppPurchaseIds => {
    vip,
  };

  static Set<String> get allProductIds => {
    ...subscriptionIds,
    ...inAppPurchaseIds,
  };
}
