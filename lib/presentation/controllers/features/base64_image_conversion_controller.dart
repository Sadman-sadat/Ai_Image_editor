import 'dart:convert';
import 'dart:io';
import 'package:appear_ai_image_editor/presentation/controllers/image_processing/image_processing_carousel_controller.dart';
import 'package:get/get.dart';
import 'package:appear_ai_image_editor/data/models/base64_image_conversion_model.dart';
import 'package:appear_ai_image_editor/data/services/features/base64_image_conversion_service.dart';
import 'package:appear_ai_image_editor/data/services/image_storage_service.dart';
import 'package:appear_ai_image_editor/data/utility/urls.dart';
import 'package:appear_ai_image_editor/presentation/widgets/snack_bar_message.dart';
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

  // Reset state to initial
  void _resetState() {
    _selectedImage = null;
    _processedImageUrl = '';
    _base64ImageString = '';
    _errorMessage = '';
    _inProgress = false;
    update();
  }

  // Handle errors uniformly
  void _handleError(String error) {
    _errorMessage = error;
    showSnackBarMessage(
      title: 'Error',
      message: _errorMessage,
    );
    print(_errorMessage);
    _resetState();
  }

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

        // If conversion failed, reset state
        if (!isSuccess) {
          _resetState();
        }
      }
    } catch (e) {
      _handleError('Error picking image: $e');
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
        throw Exception('No image selected');
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
      _handleError('Error converting or uploading image: $e');
    } finally {
      _inProgress = false;
      update();
    }

    return isSuccess;
  }

  Future<String?> getStoredBase64Output(String base64Image) async {
    final storedData = _storageService.getImageData(
      base64Image: base64Image,
      processingType: 'base64_conversion',
    );

    return storedData?['base64Image'];
  }

  Future<bool> pickImageFromFile(File imageFile) async {
    _selectedImage = imageFile;
    return await convertToBase64AndUpload();
  }

  void clearCurrentImage() {
    final carouselController = Get.find<ImageProcessingCarouselController>();
    carouselController.cancelConversion();
    _resetState();
  }
}
