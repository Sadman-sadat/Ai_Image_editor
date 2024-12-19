import 'package:get/get.dart';

class HomeScreenController extends GetxController {
  final RxList<Map<String, dynamic>> _allFeatures = [
    {
      'imageUrl': 'https://i.ytimg.com/vi/7Llzzqjnc0Q/hq720.jpg',
      'title': 'Background Removal',
      'screen': 'background_removal',
    },
    {
      'imageUrl': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ3Aky-4DBKvhkapPACIOOajqox5yNJqBb-AQ&s',
      'title': 'Face Swap',
      'screen': 'face_swap',
    },
    {
      'imageUrl': 'https://ikancorp.com/prod1/wp-content/uploads/2021/01/g6nco7j51FWksJzLk7v098tJdVMJEqhU1611237455.jpg',
      'title': 'Relighting',
      'screen': 'relighting',
    },
    {
      'imageUrl': 'https://krikey-ai.ghost.io/content/images/size/w1000/2024/08/Generate-AI-Avatar-with-tools-like-Krikey-AI-to-make-animated-videos-with-voice-AI.jpg',
      'title': 'Avatar Gen',
      'screen': 'avatar_gen',
    },
    {
      'imageUrl': 'https://www.ifoto.ai/_nuxt/img/face-replace.0143a8f.webp',
      'title': 'Face Gen',
      'screen': 'head_shot_gen',
    },
    {
      'imageUrl': 'https://i.pcmag.com/imagery/articles/00sSbBtLdbrpARnLKnUr21s-5.fit_lim.size_1600x900.v1692217579.png',
      'title': 'Object Removal',
      'screen': 'object_removal',
    },
    {
      'imageUrl': 'https://zenithclipping.com/wp-content/uploads/2024/04/Image-Enhancement-Service-1024x683.jpg',
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