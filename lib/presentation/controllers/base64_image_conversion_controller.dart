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
  bool _inProgress = false;
  String _errorMessage = '';
  File? _selectedImage;
  String _processedImageUrl = '';
  String _base64ImageString = '';

  final Base64ImageConversionService _base64ImageService = Base64ImageConversionService();
  final ImageStorageService _storageService = Get.find<ImageStorageService>();

  // Getters
  bool get inProgress => _inProgress;
  String get errorMessage => _errorMessage;
  File? get selectedImage => _selectedImage;
  String get processedImageUrl => _processedImageUrl;
  String get base64ImageString => _base64ImageString;

  Future<bool> pickImage(ImageSource source) async {
    bool isSuccess = false;
    _inProgress = true;
    _errorMessage = '';
    update();

    try {
      final pickedFile = await ImagePicker().pickImage(
        source: source,
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        _selectedImage = File(pickedFile.path);
        isSuccess = await convertToBase64AndUpload();
      }
    } catch (e) {
      _errorMessage = 'Error picking image: $e';
      showSnackBarMessage(
        title: 'Error',
        message: _errorMessage,
      );
      print(_errorMessage);
    } finally {
      _inProgress = false;
      update();
    }

    return isSuccess;
  }

  Future<bool> convertToBase64AndUpload() async {
    bool isSuccess = false;
    _inProgress = true;
    _errorMessage = '';
    update();

    try {
      if (_selectedImage == null) {
        _errorMessage = 'No image selected';
        return false;
      }

      final bytes = await _selectedImage!.readAsBytes();
      final base64String = base64Encode(bytes);
      _base64ImageString = base64String;

      final storedData = _storageService.getImageData(
        base64Image: base64String,
        processingType: 'base64_conversion',
      );

      if (storedData != null && storedData['processedUrl']?.isNotEmpty == true) {
        _processedImageUrl = storedData['processedUrl']!;
        isSuccess = true;
        _inProgress = false;
        update();
        return isSuccess;
      }

      final model = Base64ImageConversionModel(
        apiKey: Urls.api_Key,
        imageBase64: base64String,
        crop: false,
      );

      final imageUrl = await _base64ImageService.convertImageToBase64(model);
      _processedImageUrl = imageUrl;
      isSuccess = true;

      // Store the processed data
      _storageService.storeImageData(
        base64Image: base64String,
        processedUrl: imageUrl,
        processingType: 'base64_conversion',
      );

    } catch (e) {
      _errorMessage = 'Error converting or uploading image: $e';
      showSnackBarMessage(
        title: 'Error',
        message: _errorMessage,
      );
      print(_errorMessage);
    } finally {
      _inProgress = false;
      update();
    }

    return isSuccess;
  }

  // Method to retrieve stored base64 output for other processing
  Future<String?> getStoredBase64Output(String base64Image) async {
    final storedData = _storageService.getImageData(
      base64Image: base64Image,
      processingType: 'base64_conversion',
    );

    return storedData?['base64Image'];
  }

  // For object removal, remove if unnecessary
  Future<bool> pickImageFromFile(File imageFile) async {
    _selectedImage = imageFile;
    return await convertToBase64AndUpload();
  }

  // Clear the current image and its data
  void clearCurrentImage() {
    _selectedImage = null;
    _processedImageUrl = '';
    _base64ImageString = '';
    _errorMessage = '';
    update();
  }
}
