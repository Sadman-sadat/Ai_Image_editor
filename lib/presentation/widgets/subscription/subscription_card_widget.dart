import 'package:appear_ai_image_editor/presentation/controllers/subscription_controller.dart';
import 'package:flutter/material.dart';

class SubscriptionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String price;
  final String discount;
  final String planId;
  final SubscriptionController controller;

  const SubscriptionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.discount,
    required this.planId,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xFF2A2A3E),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Material(
            color: const Color(0xFF1E1E32),
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              onTap: () => controller.buySubscription(planId),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Title and Subtitle
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Price with minimum width to prevent overflow
                    Container(
                      constraints: const BoxConstraints(minWidth: 70),
                      child: Text(
                        price,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        // Discount Badge
        Positioned(
          top: -12,
          right: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF6B18E5),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              discount,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
