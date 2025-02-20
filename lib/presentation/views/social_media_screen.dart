import 'package:appear_ai_image_editor/data/utility/urls.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:appear_ai_image_editor/presentation/views/subscription_screen.dart';
import 'package:url_launcher/url_launcher.dart';

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
                  Card(
                    elevation: 4,
                    color: const Color(0xFF1A1A2E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.orange.shade700, width: 1.7),
                        borderRadius: BorderRadius.circular(8), // Match card shape
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Appear',
                                  style: TextStyle(
                                    fontSize: 28,  // Keep at 24 as requested
                                    fontWeight: FontWeight.bold,
                                    foreground: Paint()
                                      ..shader = const LinearGradient(
                                        colors: [
                                          Color(0xFF368CF4),
                                          Color(0xFF368CF4),
                                          Color(0xFF368CF4),
                                          Color(0xFF368CF4),
                                          Color(0xFF8D66F8),
                                          Color(0xFF8D66F8),
                                        ],
                                      ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                                  ),
                                ),
                                const TextSpan(
                                  text: 'AI PRO',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'No Ads & Unlimited Styles Artwork',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              Get.to(const SubscriptionScreen());
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepOrange.shade500,
                              foregroundColor: Colors.white,
                              // backgroundColor: Colors.deepOrange.shade500,
                              // foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'TRY PRO NOW',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Social Media Cards
                  _buildSocialCard(
                    leading: const Icon(Icons.discord, size: 24, color: Colors.white),
                    title: 'Join our Discord channel',
                    onTap: () => _launchURL(Urls.discordUrl),
                  ),
                  const SizedBox(height: 12),

                  _buildSocialCard(
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

                  _buildSocialCard(
                    leading: const Icon(Icons.facebook, size: 24, color: Colors.white),
                    title: 'Follow on Facebook',
                    onTap: () => _launchURL(Urls.facebookUrl),
                  ),
                  const SizedBox(height: 12),

                  _buildSocialCard(
                    leading: const Icon(Icons.public, size: 24, color: Colors.white),
                    // leading: ColorFiltered(
                    //   colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    //   child: Image.asset(
                    //     'assets/icons/web-icon.png',
                    //     width: 24,
                    //     height: 24,
                    //   ),
                    // ),
                    title: 'Visit our Website',
                    onTap: () => _launchURL(Urls.website),
                  ),
                  const SizedBox(height: 24),

                  // Rating Card
                  Card(
                    elevation: 2,
                    color: const Color(0xFF1A1A2E),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => _launchURL(
                        Urls.playStoreRating,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.orange.shade700, width: 1.7), // Thin white border
                          borderRadius: BorderRadius.circular(10), // Match card shape
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16.0,
                            horizontal: 24.0,
                          ),
                          child: Row(
                            children: [
                              const Text(
                                'Rate us',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              const Spacer(), // Pushes stars to the right
                              Row(
                                children: List.generate(
                                  5, (index) => const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 2),
                                    child: Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 22, // Matches social card size
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialCard({
    required Widget leading, // Accepts either Icon or Image widget
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      color: const Color(0xFF1A1A2E),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.orange.shade700, width: 1.7), // Thin white border
            borderRadius: BorderRadius.circular(12), // Match card shape
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 24.0,
            ),
            child: Row(
              children: [
                leading, // Dynamically display Icon or Image
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
