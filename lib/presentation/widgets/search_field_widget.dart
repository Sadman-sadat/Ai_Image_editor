import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:appear_ai_image_editor/presentation/controllers/home_screen_controller.dart';
import 'package:appear_ai_image_editor/presentation/utility/app_colors.dart';

class SearchFieldWidget extends StatelessWidget {
  final String title;

  const SearchFieldWidget({
    super.key,
    required this.title
  });

  @override
  Widget build(BuildContext context) {
    final HomeScreenController controller = Get.find<HomeScreenController>();

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.04,
        vertical: 8,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: AppColors.cardGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(8),
            // border: Border.all(
            //   color: AppColors.buttonGradient[0],
            //   width: 1.0,
            // ),
          ),
          child: Obx(() => TextFormField(
            decoration: InputDecoration(
              hintText: title,
              hintStyle: const TextStyle(
                color: Colors.grey,
                //color: AppColors.buttonGradient[0],
                fontWeight: FontWeight.w400,
              ),
              fillColor: Colors.transparent,
              filled: true,
              prefixIcon: Icon(
                Icons.search_outlined,
                color: AppColors.buttonGradient[0],
                //color: Colors.grey,
              ),
              suffixIcon: controller.searchQuery.value.isNotEmpty
                  ? IconButton(
                icon: Icon(
                  Icons.clear,
                  color: AppColors.buttonGradient[0],
                ),
                onPressed: () {
                  controller.updateSearchQuery('');
                },
              )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
            style: TextStyle(
              color: AppColors.buttonGradient[0],
            ),
            onChanged: (value) {
              controller.updateSearchQuery(value);
            },
          )),
        ),
      ),
    );
  }
}
