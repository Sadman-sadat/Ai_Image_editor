import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_ai_editor/presentation/views/background_removal_screen.dart';
import 'package:image_ai_editor/presentation/views/image_enhancement_screen.dart';
import 'package:image_ai_editor/presentation/widgets/snack_bar_message.dart';

void showCustomBottomSheet(BuildContext context) {
  final screenHeight = MediaQuery.of(context).size.height;

  Get.bottomSheet(
    Container(
      constraints: BoxConstraints(
        maxHeight: screenHeight * 0.8,
      ),
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'All Features',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const Divider(),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.account_box_outlined),
                    title: const Text('Background Removal'),
                    onTap: () {
                      Get.to(() => BackgroundRemovalScreen());
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.zoom_out_map_outlined),
                    title: const Text('Image Enhancement'),
                    onTap: () {
                      Get.to(() => ImageEnhancementScreen());
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.tag_faces),
                    title: const Text('Face Swap'),
                    onTap: () {
                      showSnackBarMessage(
                        message: 'Coming soon',
                        colorText: Colors.black,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
    isScrollControlled: true,
  );
}
