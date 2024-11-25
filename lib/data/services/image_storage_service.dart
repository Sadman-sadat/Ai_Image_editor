import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class ImageStorageService extends GetxService {
  static const String _storageKey = 'image_storage';
  final _storage = GetStorage();

  final RxMap<String, Map<String, String>> imageCache = <String, Map<String, String>>{}.obs;
  static const int _maxStorageItems = 10;

  @override
  void onInit() {
    super.onInit();
    _loadFromStorage();
  }

  String _generateImageHash(String base64Image) {
    return md5.convert(utf8.encode(base64Image)).toString();
  }

  void _loadFromStorage() {
    final Map<String, dynamic>? storedData = _storage.read(_storageKey);
    if (storedData != null) {
      imageCache.value = Map<String, Map<String, String>>.from(
          storedData.map((key, value) => MapEntry(key, Map<String, String>.from(value)))
      );
    }
  }

  void _saveToStorage() {
    _storage.write(_storageKey, imageCache);
  }

  void storeImageData({
    required String base64Image,
    required String processedUrl,
    String? processingType,
  }) {
    final imageHash = _generateImageHash(base64Image);
    final storageKey = processingType != null
        ? '${processingType}_$imageHash'
        : imageHash;

    // Remove oldest item if storage limit is reached
    if (imageCache.length >= _maxStorageItems) {
      imageCache.remove(imageCache.keys.first);
    }

    // Store new data
    imageCache[storageKey] = {
      'base64Image': base64Image,
      'processedUrl': processedUrl,
    };

    _saveToStorage();
  }

  Map<String, String>? getImageData({
    required String base64Image,
    String? processingType,
  }) {
    final imageHash = _generateImageHash(base64Image);
    final storageKey = processingType != null
        ? '${processingType}_$imageHash'
        : imageHash;

    return imageCache[storageKey];
  }


  void removeImageData({
    required String base64Image,
    required String processingType,
  }) {
    final imageHash = _generateImageHash(base64Image);
    final storageKey = '${processingType}_$imageHash';

    // Remove from in-memory cache
    imageCache.remove(storageKey);

    // Remove from persistent storage
    _storage.remove(storageKey);
  }

  void clearAllData() {
    imageCache.clear();
    _storage.remove(_storageKey);
  }
}
