class SubscriptionStatusModel {
  final bool isActive;
  final bool isVip;
  final DateTime? expiryDate;
  final String? planId;
  final bool isPending;
  final bool isCancelled;

  SubscriptionStatusModel({
    required this.isActive,
    required this.isVip,
    this.expiryDate,
    this.planId,
    this.isPending = false,
    this.isCancelled = false,
  });

  factory SubscriptionStatusModel.free() {
    return SubscriptionStatusModel(
      isActive: false,
      isVip: false,
    );
  }
}