// import 'package:appear_ai_image_editor/data/services/image_storage_service.dart';
// import 'package:appear_ai_image_editor/processing_type.dart';
// import 'package:get/get.dart';
//
// mixin ImageStorageMixin {
//   final ImageStorageService _storageService = Get.find();
//
//   Future<String?> getStoredImageUrl(String base64Image, String processingType) async {
//     final storedData = _storageService.getImageData(
//       base64Image: base64Image,
//       processingType: processingType,
//     );
//
//     return storedData?['processedUrl'];
//   }
//
//   Future<void> storeProcessedImage(String base64Image, String processedUrl, String processingType) async {
//     await _storageService.storeImageData(
//       base64Image: base64Image,
//       processedUrl: processedUrl,
//       processingType: processingType,
//     );
//   }
// }