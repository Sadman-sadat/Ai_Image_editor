import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:image_ai_editor/data/models/base64_image_conversion_model.dart';
import 'package:image_ai_editor/data/services/base64_image_conversion_service.dart';
import 'package:image_ai_editor/data/services/image_storage_service.dart';
import 'package:image_ai_editor/data/utility/urls.dart';
import 'package:image_ai_editor/presentation/widgets/snack_bar_message.dart';
import 'package:image_picker/image_picker.dart';

class Base64ImageConversionController extends GetxController {
  final Base64ImageConversionService _base64ImageService = Base64ImageConversionService();
  final ImageStorageService _storageService = Get.find<ImageStorageService>();

  Rx<File?> selectedImage = Rx<File?>(null);
  RxString processedImageUrl = ''.obs;
  RxString base64ImageString = ''.obs;
  RxBool isLoading = false.obs;

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(
      source: source,
      maxWidth: 1080,
      maxHeight: 1080,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
      await convertToBase64AndUpload();
    }
  }

  Future<void> convertToBase64AndUpload() async {
    if (selectedImage.value == null) return;

    isLoading.value = true;
    try {
      final bytes = await selectedImage.value!.readAsBytes();
      final base64String = base64Encode(bytes);
      base64ImageString.value = base64String;

      final storedData = _storageService.getImageData(
        base64Image: base64String,
        processingType: 'base64_conversion', // You might want to add this to ProcessingType as well
      );

      if (storedData != null && storedData['processedUrl']?.isNotEmpty == true) {
        processedImageUrl.value = storedData['processedUrl']!;
        isLoading.value = false;
        return;
      }

      final model = Base64ImageConversionModel(
        apiKey: Urls.api_Key,
        imageBase64: base64String,
        crop: false,
      );

      final imageUrl = await _base64ImageService.convertImageToBase64(model);
      processedImageUrl.value = imageUrl;

      // Store the processed data
      _storageService.storeImageData(
        base64Image: base64String,
        processedUrl: imageUrl,
        processingType: 'base64_conversion',
      );

    } catch (e) {
      showSnackBarMessage(
        title: 'Error',
        message: 'Error converting or uploading image: $e',
      );
      print('Error converting or uploading image: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Method to retrieve stored base64 output for other processing
  Future<String?> getStoredBase64Output(String base64Image) async {
    final storedData = _storageService.getImageData(
      base64Image: base64Image,
      processingType: 'base64_conversion',
    );

    return storedData?['base64Image'];
  }
  //for object removal remove if necessary
  Future<void> pickImageFromFile(File imageFile) async {
    selectedImage.value = imageFile;
    await convertToBase64AndUpload();
  }

  // Clear the current image and its data
  void clearCurrentImage() {
    selectedImage.value = null;
    processedImageUrl.value = '';
    base64ImageString.value = '';
  }
}
