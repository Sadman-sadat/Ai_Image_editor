import 'dart:convert';
import 'package:http/http.dart' as http;

class NetworkCaller {
  Future<Map<String, dynamic>> postRequest(String url, Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw _handleError(response);
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  dynamic _handleError(dynamic error) {
    if (error is http.Response) {
      // Handle different HTTP status codes
      switch (error.statusCode) {
        case 400:
          return 'Invalid request: Please check your input parameters.';
        case 401:
          return 'Unauthorized: Please check your API key.';
        case 500:
          return 'Server error: Please try again later.';
        default:
          return 'An error occurred: ${error.statusCode} - ${error.body}';
      }
    } else if (error is Exception) {
      return 'An unknown error occurred: ${error.toString()}';
    }
    return 'An unknown error occurred. Please try again.';
  }
}

