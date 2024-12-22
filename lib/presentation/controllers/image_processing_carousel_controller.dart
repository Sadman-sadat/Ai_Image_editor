import 'package:carousel_slider/carousel_controller.dart';
import 'package:get/get.dart';

class ImageProcessingCarouselController extends GetxController {
  final List<String> carouselImages = [
    'https://i.pinimg.com/564x/11/ac/0d/11ac0ddaf6962e395f30abc61043393e.jpg',
    'https://pub-3626123a908346a7a8be8d9295f44e26.r2.dev/livewire-tmp/jznUIJy6FoM1nUkXZBCvhyrlbetau1-metabGljZW5zZWQtaW1hZ2UuanBn-.jpg',
    'https://pub-3626123a908346a7a8be8d9295f44e26.r2.dev/livewire-tmp/9Mhbi9i0r9ADMfTpwTOqmyEQQyb6AK-metaSEQtd2FsbHBhcGVyLXNoYWhydWtoLWtoYW4tc3JrLWFjdG9yLWhlcm9bMV0uanBn-.jpg',
  ];

  final CarouselSliderController carouselController = CarouselSliderController();
  String selectedImage = '';
  int currentIndex = 0;

  @override
  void onInit() {
    super.onInit();
    if (carouselImages.isNotEmpty) {
      selectedImage = carouselImages[0];
    }
  }

  void setSelectedImage(String image) {
    selectedImage = image;
    update();
  }

  void updateSelectedIndex(int index) {
    currentIndex = index;
    selectedImage = carouselImages[index];
    update();
  }

  void navigateToImage(int index) {
    carouselController.animateToPage(index);
    updateSelectedIndex(index);
  }
}

