import 'package:get/get.dart';

class HomeScreenController extends GetxController {
  final RxList<Map<String, dynamic>> _allFeatures = [
    {
      'imageAsset': 'assets/images/background-removal.png',
      'title': 'Background Removal',
      'screen': 'background_removal',
    },
    {
      'imageAsset': 'assets/images/face_swap.png',
      'title': 'Face Swap',
      'screen': 'face_swap',
    },
    // {
    //   'imageAsset': 'assets/images/relighting.png',
    //   'title': 'Relighting',
    //   'screen': 'relighting',
    // },
    {
      'imageAsset': 'assets/images/interior-design.png',
      'title': 'Interior Design Generation',
      'screen': 'interior_design_gen',
    },
    {
      'imageAsset': 'assets/images/create-avatar.png',
      'title': 'Avatar Gen',
      'screen': 'avatar_gen',
    },
    {
      'imageAsset': 'assets/images/face_gen.png',
      'title': 'Face Gen',
      'screen': 'head_shot_gen',
    },
    {
      'imageAsset': 'assets/images/object_removal.png',
      'title': 'Object Removal',
      'screen': 'object_removal',
    },
    {
      'imageAsset': 'assets/images/image_enhancer.png',
      'title': 'Image Enhancement',
      'screen': 'image_enhancement',
    },
  ].obs;

  final RxList<Map<String, dynamic>> filteredFeatures = <Map<String, dynamic>>[].obs;
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Initially show all features
    filteredFeatures.value = _allFeatures;

    // Listen to search query changes
    ever(searchQuery, (_) => _filterFeatures());
  }

  void _filterFeatures() {
    if (searchQuery.value.isEmpty) {
      filteredFeatures.value = _allFeatures;
    } else {
      filteredFeatures.value = _allFeatures
          .where((feature) =>
          feature['title'].toLowerCase().contains(searchQuery.value.toLowerCase()))
          .toList();
    }
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query.trim();
  }

  void navigateToFeature(String screenName) {
    switch (screenName) {
      case 'background_removal':
        Get.toNamed('/background_removal');
        break;
      case 'face_swap':
        Get.toNamed('/face_swap');
        break;
      case 'head_shot_gen':
        Get.toNamed('/head_shot_gen');
        break;
      case 'relighting':
        Get.toNamed('/relighting');
        break;
      case 'interior_design_gen':
        Get.toNamed('/interior_design_gen');
        break;
      case 'avatar_gen':
        Get.toNamed('/avatar_gen');
        break;
      case 'object_removal':
        Get.toNamed('/object_removal');
        break;
      case 'image_enhancement':
        Get.toNamed('/image_enhancement');
        break;
    }
  }
}