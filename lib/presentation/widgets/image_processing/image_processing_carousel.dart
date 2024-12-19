import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:image_ai_editor/presentation/controllers/image_processing_carousel_controller.dart';

class ImageProcessingCarousel extends StatelessWidget {
  ImageProcessingCarousel({super.key}) {
    // Initialize the controller when the widget is created
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
                itemCount: controller.carouselImages.length,
                itemBuilder: (context, index, realIndex) {
                  return GestureDetector(
                    onTap: () {
                      controller.setSelectedImage(controller.carouselImages[index]);
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: controller.selectedImage == controller.carouselImages[index]
                              ? Colors.blue
                              : Colors.grey,
                          width: controller.selectedImage == controller.carouselImages[index] ? 3 : 1,
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
                  aspectRatio: 16/9,
                  onPageChanged: (index, reason) {
                    controller.setSelectedImage(controller.carouselImages[index]);
                  },
                ),
              );
            }
        ),
        const SizedBox(height: 20),
        const Text(
          'Select an image for face swap',
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}