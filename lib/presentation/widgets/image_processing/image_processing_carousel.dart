import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:image_ai_editor/presentation/controllers/image_processing_carousel_controller.dart';

class ImageProcessingCarousel extends StatelessWidget {
  ImageProcessingCarousel({super.key}) {
    Get.find<ImageProcessingCarouselController>();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GetBuilder<ImageProcessingCarouselController>(
          builder: (controller) {
            return CarouselSlider.builder(
              carouselController: controller.carouselController,
              itemCount: controller.carouselImages.length,
              itemBuilder: (context, index, realIndex) {
                return GestureDetector(
                  onTap: () {
                    controller.setSelectedImage(
                        controller.carouselImages[index]);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: controller.selectedImage ==
                            controller.carouselImages[index]
                            ? Colors.blue
                            : Colors.grey,
                        width: controller.selectedImage ==
                            controller.carouselImages[index]
                            ? 3
                            : 1,
                      ),
                      image: DecorationImage(
                        image: NetworkImage(controller.carouselImages[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
              options: CarouselOptions(
                height: 450,
                enlargeCenterPage: true,
                autoPlay: false,
                aspectRatio: 16 / 9,
                onPageChanged: (index, reason) {
                  controller.updateSelectedIndex(index);
                },
              ),
            );
          },
        ),
        const SizedBox(height: 20),
        // Selectable Dot Indicators
        GetBuilder<ImageProcessingCarouselController>(
          builder: (controller) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: controller.carouselImages.asMap().entries.map((entry) {
                int index = entry.key;
                return GestureDetector(
                  onTap: () {
                    // Navigate to selected image and update carousel position
                    controller.navigateToImage(index);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: controller.selectedImage ==
                        controller.carouselImages[index]
                        ? 16
                        : 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: controller.selectedImage ==
                          controller.carouselImages[index]
                          ? Colors.blue.shade700
                          : Colors.blue.shade100,
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
        const SizedBox(height: 20),
        const Text(
          'Swap and Select an image to swap face',
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
