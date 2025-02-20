import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:appear_ai_image_editor/presentation/controllers/image_processing_carousel_controller.dart';

class ImageProcessingCarousel extends StatelessWidget {
  ImageProcessingCarousel({super.key}) {
    final controller = Get.find<ImageProcessingCarouselController>();
    // Ensure carousel initializes with the correct image
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.carouselController.jumpToPage(controller.currentIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GetBuilder<ImageProcessingCarouselController>(
          builder: (controller) {
            return CarouselSlider.builder(
              carouselController: controller.carouselController,
              itemCount: controller.carouselImages.length,
              itemBuilder: (context, index, realIndex) {
                final asset = controller.carouselImages[index];
                final isSelected = controller.currentIndex == index;

                return GestureDetector(
                  onTap: () {
                    controller.setSelectedImage(asset.assetPath);
                    controller.carouselController.animateToPage(index);
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.01, // Adjust margin
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(screenWidth * 0.03),
                      border: Border.all(
                        color: isSelected ? Colors.orange : Colors.grey,
                        width: isSelected ? 3 : 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(screenWidth * 0.02),
                      child: Image.asset(
                        asset.assetPath,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
              options: CarouselOptions(
                height: screenHeight * 0.4, // Adjust height
                enlargeCenterPage: true,
                autoPlay: false,
                aspectRatio: screenWidth / screenHeight, // Maintain aspect ratio
                initialPage: controller.currentIndex,
                onPageChanged: (index, reason) {
                  controller.updateSelectedIndex(index);
                },
              ),
            );
          },
        ),
        SizedBox(height: screenHeight * 0.02), // Adjust spacing
        GetBuilder<ImageProcessingCarouselController>(
          builder: (controller) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: controller.carouselImages.asMap().entries.map((entry) {
                int index = entry.key;
                final isSelected = controller.currentIndex == index;

                return GestureDetector(
                  onTap: () {
                    controller.navigateToImage(index);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: isSelected ? screenWidth * 0.04 : screenWidth * 0.02,
                    height: screenHeight * 0.01,
                    margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(screenWidth * 0.01),
                      color: isSelected
                          ? Colors.orange.shade700
                          : Colors.orange.shade100,
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
        SizedBox(height: screenHeight * 0.05), // Adjust spacing
        Text(
          'Select an image to swap face',
          style: TextStyle(
            fontSize: screenWidth * 0.045, // Responsive font size
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
