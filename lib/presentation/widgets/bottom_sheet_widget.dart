import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_ai_editor/presentation/views/avatar_gen_screen.dart';
import 'package:image_ai_editor/presentation/views/background_removal_screen.dart';
import 'package:image_ai_editor/presentation/views/face_swap_screen.dart';
import 'package:image_ai_editor/presentation/views/head_shot_gen_screen.dart';
import 'package:image_ai_editor/presentation/views/image_enhancement_screen.dart';
import 'package:image_ai_editor/presentation/views/object_removal_screen.dart';
import 'package:image_ai_editor/presentation/views/relighting_screen.dart';

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
                      Get.to(() => const BackgroundRemovalScreen());
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.zoom_out_map_outlined),
                    title: const Text('Image Enhancement'),
                    onTap: () {
                      Get.to(() => const ImageEnhancementScreen());
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.border_color_outlined),
                    title: const Text('Object Removal'),
                    onTap: () {
                      Get.to(() => const ObjectRemovalScreen());
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.emoji_people_outlined),
                    title: const Text('Avatar Generator'),
                    onTap: () {
                      Get.to(() => const AvatarGenScreen());
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.light_outlined),
                    title: const Text('Relighting'),
                    onTap: () {
                      Get.to(() => const RelightingScreen());
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.tag_faces),
                    title: const Text('Face Gen'),
                    onTap: () {
                      Get.to(() => const HeadShotGenScreen());
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.face_retouching_natural_outlined),
                    title: const Text('Face Swap'),
                    onTap: () {
                      Get.to(() => const FaceSwapScreen());
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
