import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:appear_ai_image_editor/presentation/utility/app_colors.dart';
import 'package:appear_ai_image_editor/presentation/views/features/avatar_gen_screen.dart';
import 'package:appear_ai_image_editor/presentation/views/features/background_removal_screen.dart';
import 'package:appear_ai_image_editor/presentation/views/features/face_swap_screen.dart';
import 'package:appear_ai_image_editor/presentation/views/features/head_shot_gen_screen.dart';
import 'package:appear_ai_image_editor/presentation/views/features/image_enhancement_screen.dart';
import 'package:appear_ai_image_editor/presentation/views/features/object_removal_screen.dart';
import 'package:appear_ai_image_editor/presentation/views/features/relighting_screen.dart';

void showCustomBottomSheet(BuildContext context) {
  final screenHeight = MediaQuery.of(context).size.height;

  Get.bottomSheet(
    Container(
      constraints: BoxConstraints(
        maxHeight: screenHeight * 0.8,
      ),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: AppColors.cardGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        // border: Border.all(
        //   color: AppColors.buttonGradient[0],
        //   width: 1.0,
        // ),
      ),
      // decoration: const BoxDecoration(
      //   color: Colors.white,
      //   borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      // ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'All Features',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const Divider(),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.account_box_outlined, color: Colors.white,),
                    title: const Text('Background Removal', style: TextStyle(fontSize: 16, color: Colors.white),),
                    onTap: () {
                      Get.to(() => const BackgroundRemovalScreen());
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.zoom_out_map_outlined, color: Colors.white,),
                    title: const Text('Image Enhancement', style: TextStyle(fontSize: 16, color: Colors.white),),
                    onTap: () {
                      Get.to(() => const ImageEnhancementScreen());
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.border_color_outlined, color: Colors.white,),
                    title: const Text('Object Removal', style: TextStyle(fontSize: 16, color: Colors.white),),
                    onTap: () {
                      Get.to(() => const ObjectRemovalScreen());
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.emoji_people_outlined, color: Colors.white,),
                    title: const Text('Avatar Generator', style: TextStyle(fontSize: 16, color: Colors.white),),
                    onTap: () {
                      Get.to(() => const AvatarGenScreen());
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.light_outlined, color: Colors.white,),
                    title: const Text('Relighting', style: TextStyle(fontSize: 16, color: Colors.white),),
                    onTap: () {
                      Get.to(() => const RelightingScreen());
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.tag_faces, color: Colors.white,),
                    title: const Text('Face Gen', style: TextStyle(fontSize: 16, color: Colors.white),),
                    onTap: () {
                      Get.to(() => const HeadShotGenScreen());
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.face_retouching_natural_outlined, color: Colors.white,),
                    title: const Text('Face Swap', style: TextStyle(fontSize: 16, color: Colors.white),),
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
