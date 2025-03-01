import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class ConsentService extends GetxController {
  bool isConsentDetermined = false;
  bool isConsentComplete = false;

  Future<void> initialize() async {
    try {
      final params = ConsentRequestParameters();

      // for testing
      // final params = ConsentRequestParameters(
      //   consentDebugSettings: kDebugMode
      //       ? ConsentDebugSettings(
      //     debugGeography: DebugGeography.debugGeographyEea,
      //     // testIdentifiers: ["FDD9D5C7-906A-4466-BD96-E0917E80DBBC"],
      //   )
      //       : null,
      // );

      debugPrint("[ConsentService] Requesting consent info update");

      final completer = Completer<void>();

      ConsentInformation.instance.requestConsentInfoUpdate(
        params,
            () async {
          debugPrint("[ConsentService] Consent info updated successfully");

          final status = await ConsentInformation.instance.getConsentStatus();
          debugPrint("[ConsentService] Initial consent status: $status");

          final isFormAvailable =
          await ConsentInformation.instance.isConsentFormAvailable();
          debugPrint("[ConsentService] Consent form available: $isFormAvailable");

          if (isFormAvailable) {
            await _loadAndShowConsentForm();
          }

          // Initialize mobile ads regardless of consent form availability
          await _initializeAds();

          isConsentDetermined = true;
          isConsentComplete = true;
          update();
          completer.complete();
        },
            (error) {
          debugPrint("[ConsentService] Error requesting consent: $error");
          // Still initialize ads even if there's an error
          _initializeAds();
          isConsentDetermined = true;
          isConsentComplete = true;
          update();
          completer.complete();
        },
      );

      return completer.future;
    } catch (e) {
      debugPrint("[ConsentService] Exception in initialize: $e");
      // Initialize ads even if there's an exception
      await _initializeAds();
      isConsentDetermined = true;
      isConsentComplete = true;
      update();
    }
  }

  Future<void> _loadAndShowConsentForm() async {
    final completer = Completer<void>();

    try {
      debugPrint("[ConsentService] Loading consent form");

      ConsentForm.loadConsentForm(
            (ConsentForm consentForm) async {
          debugPrint("[ConsentService] Consent form loaded successfully");

          final status = await ConsentInformation.instance.getConsentStatus();
          debugPrint("[ConsentService] Consent status before showing form: $status");

          if (status == ConsentStatus.required) {
            debugPrint("[ConsentService] Showing consent form");

            consentForm.show(
                  (FormError? formError) {
                if (formError != null) {
                  debugPrint(
                      "[ConsentService] Error showing form: ${formError.message}");
                } else {
                  debugPrint("[ConsentService] Consent form closed without error");
                }
                completer.complete();
              },
            );
          } else {
            debugPrint("[ConsentService] Consent not required, skipping form");
            completer.complete();
          }
        },
            (FormError formError) {
          debugPrint("[ConsentService] Error loading form: ${formError.message}");
          completer.complete();
        },
      );

      return completer.future;
    } catch (e) {
      debugPrint("[ConsentService] Exception in _loadAndShowConsentForm: $e");
      completer.complete();
      return completer.future;
    }
  }

  Future<bool> changePrivacyPreference() async {
    final completer = Completer<bool>();
    bool formWasShown = false;

    try {
      debugPrint("[ConsentService] Starting privacy preference change");

      // Force reset the consent info to ensure we can show the form again
      await ConsentInformation.instance.reset();
      debugPrint("[ConsentService] Consent information reset");

      final params = ConsentRequestParameters();

      // test
      // // Use the same parameters as in initialize to ensure consistency
      // final params = ConsentRequestParameters(
      //   consentDebugSettings: kDebugMode
      //       ? ConsentDebugSettings(
      //     debugGeography: DebugGeography.debugGeographyEea,
      //   )
      //       : null,
      // );

      ConsentInformation.instance.requestConsentInfoUpdate(
        params,
            () async {
          debugPrint("[ConsentService] Consent info updated for preference change");

          final isFormAvailable = await ConsentInformation.instance.isConsentFormAvailable();
          debugPrint("[ConsentService] Consent form available: $isFormAvailable");

          if (isFormAvailable) {
            debugPrint("[ConsentService] Loading consent form for preference change");

            ConsentForm.loadConsentForm(
                  (consentForm) {
                debugPrint("[ConsentService] Showing consent form for preference change");

                consentForm.show(
                      (formError) async {
                    if (formError != null) {
                      debugPrint("[ConsentService] Error showing form for preference change: ${formError.message}");
                      completer.complete(false);
                    } else {
                      debugPrint("[ConsentService] Consent form closed successfully for preference change");
                      formWasShown = true;

                      // Reinitialize ads with new consent
                      await _initializeAds();
                      completer.complete(true);
                    }
                  },
                );
              },
                  (formError) {
                debugPrint("[ConsentService] Error loading form for preference change: ${formError.message}");
                completer.complete(false);
              },
            );
          } else {
            debugPrint("[ConsentService] No consent form available for preference change");
            completer.complete(false);
          }
        },
            (error) {
          debugPrint("[ConsentService] Error requesting consent for preference change: $error");
          completer.complete(false);
        },
      );

      return completer.future;
    } catch (e) {
      debugPrint("[ConsentService] Exception in changePrivacyPreference: $e");
      completer.complete(false);
      return completer.future;
    }
  }

  Future<void> _initializeAds() async {
    try {
      debugPrint("[ConsentService] Initializing Mobile Ads");
      await MobileAds.instance.initialize();
      debugPrint("[ConsentService] Mobile Ads initialized successfully");
    } catch (e) {
      debugPrint("[ConsentService] Error initializing Mobile Ads: $e");
    }
  }
}
