import 'dart:convert';
import 'package:appear_ai_image_editor/data/models/base64_image_conversion_model.dart';
import 'package:appear_ai_image_editor/data/services/network/network_caller.dart';
import 'package:appear_ai_image_editor/data/utility/urls.dart';

class Base64ImageConversionService {
  final NetworkCaller _networkCaller = NetworkCaller();

  Future<String> convertImageToBase64(Base64ImageConversionModel model) async {
    try {
      // Log the request body for debugging purposes
      print('Request Body: ${jsonEncode(model.toJson())}');

      final responseData = await _networkCaller.postRequest(
        Urls.base64Conversion,
        model.toJson(),
      );

      // Handle response based on status
      if (responseData['status'] == 'success') {
        return responseData['link']; // Return the image URL from the response
      } else {
        throw Exception("Image upload failed: ${responseData['message'] ?? 'Unknown error'}");
      }
    } catch (e) {
      print('Error in convertImageToBase64: $e');
      rethrow; // Rethrow to let the UI handle the error appropriately
    }
  }
}
