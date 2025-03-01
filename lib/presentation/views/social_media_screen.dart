import 'package:appear_ai_image_editor/data/utility/urls.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:appear_ai_image_editor/presentation/widgets/social_media/social_media_privacy_consent_card.dart';
import 'package:appear_ai_image_editor/presentation/widgets/social_media/social_media_pro_card.dart';
import 'package:appear_ai_image_editor/presentation/widgets/social_media/social_media_rating_card.dart';
import 'package:appear_ai_image_editor/presentation/widgets/social_media/social_media_social_card.dart';

class SocialMediaScreen extends StatelessWidget {
  const SocialMediaScreen({super.key});

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Could not launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final contentWidth = screenWidth > 600 ? 400.0 : screenWidth * 0.9;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: contentWidth,
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Pro Card
                  const SizedBox(height: 34),
                  const ProCard(),
                  const SizedBox(height: 24),

                  // Social Media Cards
                  SocialCard(
                    leading: const Icon(Icons.discord, size: 24, color: Colors.white),
                    title: 'Join our Discord channel',
                    onTap: () => _launchURL(Urls.discordUrl),
                  ),
                  const SizedBox(height: 12),

                  SocialCard(
                    leading: ColorFiltered(
                      colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                      child: Image.asset(
                        'assets/icons/instagram-icon.png',
                        width: 24,
                        height: 24,
                      ),
                    ),
                    title: 'Follow on Instagram',
                    onTap: () => _launchURL(Urls.instagramUrl),
                  ),
                  const SizedBox(height: 12),

                  SocialCard(
                    leading: const Icon(Icons.facebook, size: 24, color: Colors.white),
                    title: 'Follow on Facebook',
                    onTap: () => _launchURL(Urls.facebookUrl),
                  ),
                  const SizedBox(height: 12),

                  SocialCard(
                    leading: const Icon(Icons.public, size: 24, color: Colors.white),
                    title: 'Visit our Website',
                    onTap: () => _launchURL(Urls.website),
                  ),
                  const SizedBox(height: 12),

                  // Rating Card
                  const RatingCard(ratingUrl: Urls.playStoreRating),
                  const SizedBox(height: 24),

                  // Privacy Consent Card
                  const PrivacyConsentCard(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
