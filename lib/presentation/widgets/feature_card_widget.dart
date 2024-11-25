import 'package:flutter/material.dart';

class FeatureCardWidget extends StatelessWidget {
  final String imageUrl;
  final String title;
  final VoidCallback onButtonPressed;

  const FeatureCardWidget({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 300;

        return Card(
          elevation: 3,
          color: Colors.white,
          surfaceTintColor: Colors.white,
          clipBehavior: Clip.antiAlias, // Added to ensure clean edges
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.22, // Reduced overall height
            child: Column(
              children: [
                // Larger image container
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.17, // Increased image height
                  width: double.infinity,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                // Smaller content container with reduced padding
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Reduced padding
                    child: isSmallScreen
                        ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _buildCardContent(),
                    )
                        : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: _buildCardContent(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildCardContent() {
    return [
      Flexible(
        child: Text(
          title,
          maxLines: 1, // Changed to 1 line to save space
          style: const TextStyle(
            overflow: TextOverflow.ellipsis,
            fontSize: 13, // Slightly reduced font size
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      const SizedBox(width: 8),
      ElevatedButton(
        onPressed: onButtonPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[300],
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4), // Reduced padding
          minimumSize: const Size(60, 24), // Smaller minimum size
          textStyle: const TextStyle(fontSize: 11), // Smaller font size
        ),
        child: const Text('Try Out'),
      ),
    ];
  }
}

