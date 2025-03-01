import 'package:appear_ai_image_editor/data/services/consent_service.dart';
import 'package:appear_ai_image_editor/presentation/widgets/snack_bar_message.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrivacyConsentCard extends StatelessWidget {
  const PrivacyConsentCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: const Color(0xFF1A1A2E),
      child: InkWell(
        onTap: () async {
          // Show loading indicator
          Get.dialog(
            const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            barrierDismissible: false,
          );

          // Get ConsentService instance and call changePrivacyPreference
          final consentService = Get.find<ConsentService>();
          final result = await consentService.changePrivacyPreference();

          // Close loading dialog
          Get.back();

          // Show result message
          showSnackBarMessage(title: 'Privacy Settings', message: result
              ? 'Privacy preferences updated successfully'
              : 'No changes were made to privacy settings', colorText: Colors.white);
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.orange.shade700, width: 1.7),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 24.0,
            ),
            child: Row(
              children: [
                Icon(Icons.privacy_tip, size: 24, color: Colors.white),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Personalized Ads & Privacy',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }
}