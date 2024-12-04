import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_ai_editor/presentation/controllers/home_screen_controller.dart';

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
        horizontal: MediaQuery.of(context).size.width * 0.05,
        vertical: 8,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Obx(() => TextFormField(
          decoration: InputDecoration(
            hintText: title,
            fillColor: Colors.purple.shade800.withOpacity(0.9),
            filled: true,
            prefixIcon: const Icon(Icons.search_outlined, color: Colors.grey,),
            suffixIcon: controller.searchQuery.value.isNotEmpty
                ? IconButton(
              icon: const Icon(Icons.clear, color: Colors.grey,),
              onPressed: () {
                controller.updateSearchQuery('');
              },
            )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: (value) {
            controller.updateSearchQuery(value);
          },
        )),
      ),
    );
  }
}

