import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class RatingCard extends StatelessWidget {
  final String ratingUrl;

  const RatingCard({
    Key? key,
    required this.ratingUrl,
  }) : super(key: key);

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
    return Card(
      elevation: 2,
      color: const Color(0xFF1A1A2E),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _launchURL(ratingUrl),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.orange.shade700, width: 1.7),
            borderRadius: BorderRadius.circular(10),
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
                const Spacer(),
                Row(
                  children: List.generate(
                    5, (index) => const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2),
                    child: Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 22,
                    ),
                  ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}