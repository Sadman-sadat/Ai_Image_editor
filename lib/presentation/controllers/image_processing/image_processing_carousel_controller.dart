import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:appear_ai_image_editor/data/models/base64_image_conversion_model.dart';
import 'package:appear_ai_image_editor/data/services/features/base64_image_conversion_service.dart';
import 'package:appear_ai_image_editor/data/utility/urls.dart';

class ImageProcessingCarouselController extends GetxController {
  final CarouselSliderController carouselController = CarouselSliderController();
  final List<AssetImageData> _carouselImages = [
    AssetImageData(
      assetPath: 'assets/face_swap/captain_america.jpg',
      displayName: 'Face 1',
    ),
    AssetImageData(
      assetPath: 'assets/face_swap/car.jpg',
      displayName: 'Face 2',
    ),
    AssetImageData(
      assetPath: 'assets/face_swap/pirate.jpg',
      displayName: 'Face 3',
    ),
    AssetImageData(
      assetPath: 'assets/face_swap/harry_porter.jpg',
      displayName: 'Face 4',
    ),
    AssetImageData(
      assetPath: 'assets/face_swap/hermione.jpg',
      displayName: 'Face 5',
    ),
    AssetImageData(
      assetPath: 'assets/face_swap/ironman.jpg',
      displayName: 'Face 6',
    ),
    AssetImageData(
      assetPath: 'assets/face_swap/mona_lisa.jpg',
      displayName: 'Face 7',
    ),
    AssetImageData(
      assetPath: 'assets/face_swap/princess.jpg',
      displayName: 'Face 8',
    ),
    AssetImageData(
      assetPath: 'assets/face_swap/superman.jpg',
      displayName: 'Face 9',
    ),
    AssetImageData(
      assetPath: 'assets/face_swap/thor.jpg',
      displayName: 'Face 10',
    ),
    AssetImageData(
      assetPath: 'assets/face_swap/wonder_woman.jpg',
      displayName: 'Face 11',
    ),
  ];

  final Base64ImageConversionService _base64ImageService = Base64ImageConversionService();

  String _selectedAssetPath = '';
  String _convertedImageUrl = '';
  bool _isConverting = false;
  bool _isCancelled = false;
  int _currentIndex = 0;
  Map<String, String> _convertedImages = {};  // Cache for converted images

  // Getters
  List<AssetImageData> get carouselImages => _carouselImages;
  bool get isConverting => _isConverting;
  bool get isCancelled => _isCancelled;
  String get selectedImage => _convertedImageUrl;
  String get selectedAssetPath => _selectedAssetPath;
  int get currentIndex => _currentIndex;

  @override
  void onInit() {
    super.onInit();
    if (_carouselImages.isNotEmpty) {
      setSelectedImage(_carouselImages[0].assetPath);
    }
  }

  Future<void> convertSelectedAsset() async {
    if (_selectedAssetPath.isEmpty) return;

    if (_convertedImages.containsKey(_selectedAssetPath)) {
      _convertedImageUrl = _convertedImages[_selectedAssetPath]!;
      update();
      return;
    }

    try {
      _isCancelled = false;
      _isConverting = true;
      update();

      if (_isCancelled) {
        _cleanupConversion();
        return;
      }

      final ByteData data = await rootBundle.load(_selectedAssetPath);

      if (_isCancelled) {
        _cleanupConversion();
        return;
      }

      final List<int> bytes = data.buffer.asUint8List();
      final String base64String = base64Encode(bytes);

      if (_isCancelled) {
        _cleanupConversion();
        return;
      }

      final model = Base64ImageConversionModel(
        apiKey: Urls.api_Key,
        imageBase64: base64String,
        crop: false,
      );

      final convertedUrl = await _base64ImageService.convertImageToBase64(model);

      if (_isCancelled) {
        _cleanupConversion();
        return;
      }

      _convertedImages[_selectedAssetPath] = convertedUrl;
      _convertedImageUrl = convertedUrl;

    } catch (e) {
      print('Error converting asset image: $e');
      if (!_isCancelled) {
        _convertedImageUrl = '';
      }
    } finally {
      if (!_isCancelled) {
        _isConverting = false;
        update();
      }
    }
  }

  void _cleanupConversion() {
    _isConverting = false;
    _convertedImageUrl = '';
    update();
  }

  void cancelConversion() {
    _isCancelled = true;
    _cleanupConversion();
  }

  void setSelectedImage(String assetPath) {
    _selectedAssetPath = assetPath;
    _currentIndex = _carouselImages.indexWhere((image) => image.assetPath == assetPath);
    _convertedImageUrl = _convertedImages[assetPath] ?? '';
    update();
  }

  void updateSelectedIndex(int index) {
    _currentIndex = index;
    setSelectedImage(_carouselImages[index].assetPath);
  }

  void navigateToImage(int index) {
    carouselController.animateToPage(index);
    updateSelectedIndex(index);
  }

  @override
  void onClose() {
    cancelConversion();
    _convertedImageUrl = '';
    _selectedAssetPath = '';
    _convertedImages.clear();
    super.onClose();
  }
}

class AssetImageData {
  final String assetPath;
  final String displayName;

  AssetImageData({
    required this.assetPath,
    required this.displayName,
  });
}
