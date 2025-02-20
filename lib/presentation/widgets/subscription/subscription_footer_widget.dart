import 'package:appear_ai_image_editor/data/utility/urls.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text.rich(
        TextSpan(
          children: [
            WidgetSpan(
              child: TextButton(
                onPressed: () async {
                  final Uri url = Uri.parse(Urls.privacyPolicyUrl);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  }
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Privacy Policy',
                  style: TextStyle(
                    color: Colors.white70,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            TextSpan(
              text: '  |  ',
              style: TextStyle(
                color: Colors.white.withOpacity(0.3),
              ),
            ),
            WidgetSpan(
              child: TextButton(
                onPressed: () {
                  // Handle Terms of Service tap
                  print('Terms of Service tapped');
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Terms of Service',
                  style: TextStyle(
                    color: Colors.white70,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
        ),
        style: const TextStyle(fontSize: 14),
      ),
    );
  }
}
