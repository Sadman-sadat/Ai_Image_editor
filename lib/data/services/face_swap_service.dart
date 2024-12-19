import 'dart:convert';
import 'package:image_ai_editor/data/models/face_swap_model.dart';
import 'package:image_ai_editor/data/services/network_caller.dart';
import 'package:image_ai_editor/data/utility/urls.dart';

class FaceSwapService {
  final NetworkCaller _networkCaller = NetworkCaller();

  Future<Map<String, dynamic>> swapFace(FaceSwapModel model) async {
    try {
      // Step 1: Log the request body
      print('Face Swap Request Body: ${jsonEncode(model.toJson())}');

      final responseData = await _networkCaller.postRequest(
        Urls.faceSwap,
        model.toJson(),
      );

      // Step 2: Handle the response based on status
      if (responseData['status'] == 'success') {
        print('Face Swap processing. Tracker ID: ${responseData['id']}');
        return {
          'output': responseData['output'][0],
          'id': responseData['id'],
          'generationTime': responseData['generationTime'],
        };
      } else if (responseData['status'] == 'processing') {
        print('processing: $responseData');
        return {
          'id': responseData['id'],
          'generationTime': responseData['generationTime'],
        };
      } else {
        // Step 3: Log the error message from the response
        print('Error: ${responseData['message']}');
        throw Exception("Face Swap request failed: ${responseData['message'] ?? 'Unknown error'}");
      }
    } catch (e) {
      // This will catch both network errors and our custom errors
      print('Error in swapFace: $e');
      rethrow; // Rethrow to let the UI handle the error appropriately
    }
  }
}