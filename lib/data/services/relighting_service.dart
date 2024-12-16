import 'dart:convert';
import 'package:image_ai_editor/data/models/relighting_model.dart';
import 'package:image_ai_editor/data/services/network_caller.dart';
import 'package:image_ai_editor/data/utility/urls.dart';

class RelightingService {
  final NetworkCaller _networkCaller = NetworkCaller();

  Future<Map<String, dynamic>> generateRelighting(RelightingModel model) async {
    try {
      print('Request Body: ${jsonEncode(model.toJson())}');

      final responseData = await _networkCaller.postRequest(
        Urls.relighting, // Define this URL in your Urls class
        model.toJson(),
      );

      if (responseData['status'] == 'success') {
        print('Relighting generation complete. Tracker ID: ${responseData['id']}');
        return {
          'output': responseData['output'][0],
          'id': responseData['id'],
          'generationTime': responseData['generationTime'],
        };
      } else if (responseData['status'] == 'processing') {
        print('Relighting generation in progress: $responseData');
        return {
          'id': responseData['id'],
          'generationTime': responseData['generationTime'],
        };
      } else {
        print('Error: ${responseData['message']}');
        throw Exception("Relighting generation request failed: ${responseData['message'] ?? 'Unknown error'}");
      }
    } catch (e) {
      print('Error in RelightingService: $e');
      rethrow;
    }
  }
}