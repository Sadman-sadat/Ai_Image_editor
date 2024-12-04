import 'dart:convert';
import 'package:image_ai_editor/data/models/head_shot_gen_model.dart'; // Import your HeadShotModel
import 'package:image_ai_editor/data/services/network_caller.dart';
import 'package:image_ai_editor/data/utility/urls.dart';

class HeadShotGenService {
  final NetworkCaller _networkCaller = NetworkCaller();

  Future<Map<String, dynamic>> generateHeadShot(HeadShotGenModel model) async {
    try {
      // Step 1: Log the request body
      print('Request Body: ${jsonEncode(model.toJson())}');

      final responseData = await _networkCaller.postRequest(
        Urls.headShotGen, // Assuming there's a URL for headshot generation
        model.toJson(),
      );

      // Step 2: Handle the response based on status
      if (responseData['status'] == 'success') {
        print('Headshot generation complete. Tracker ID: ${responseData['id']}');
        return {
          'output': responseData['output'][0],
          'id': responseData['id'],
          'generationTime': responseData['generationTime'],
        };
      } else if (responseData['status'] == 'processing') {
        print('Headshot generation in progress: $responseData');
        return {
          'id': responseData['id'],
          'generationTime': responseData['generationTime'],
        };
      } else {
        // Step 3: Log the error message from the response
        print('Error: ${responseData['message']}');
        throw Exception("Headshot generation request failed: ${responseData['message'] ?? 'Unknown error'}");
      }
    } catch (e) {
      // This will catch both network errors and our custom errors
      print('Error in HeadShotService: $e');
      rethrow; // Rethrow to let the UI handle the error appropriately
    }
  }
}
