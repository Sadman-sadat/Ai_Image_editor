import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NetworkCaller {
  static const int timeout = 180; // 3 minutes per request
  static const int maxTotalTime = 300; // 5 minutes total

  Future<Map<String, dynamic>> postRequest(String url, Map<String, dynamic> data) async {
    final completer = Completer<Map<String, dynamic>>();

    // Start request
    Future<void> request() async {
      try {
        print('Making POST request to: $url');
        print('Request data: ${jsonEncode(data)}');

        final response = await http.post(
          Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(data),
        ).timeout(Duration(seconds: timeout));

        print('Response status code: ${response.statusCode}');
        print('Response body: ${response.body}');

        final responseData = jsonDecode(response.body) as Map<String, dynamic>;

        if (response.statusCode == 200) {
          if (!completer.isCompleted) completer.complete(responseData);
        } else {
          if (!completer.isCompleted) completer.completeError(handleError(response));
        }
      } on TimeoutException {
        if (!completer.isCompleted) completer.completeError('Request timed out: Please try again');
      } on FormatException {
        if (!completer.isCompleted) completer.completeError('Invalid response format');
      } on http.ClientException {
        if (!completer.isCompleted) completer.completeError('Network error: Please check your connection');
      } catch (e) {
        if (!completer.isCompleted) completer.completeError('Unexpected error: ${e.toString()}');
      }
    }

    // Use Future.any to enforce maxTotalTime timeout
    Future.any([
      request(),
      Future.delayed(Duration(seconds: maxTotalTime), () {
        if (!completer.isCompleted) completer.completeError('Request timed out after $maxTotalTime seconds');
      })
    ]);

    return completer.future;
  }

  String handleError(dynamic error) {
    if (error is http.Response) {
      try {
        final errorData = jsonDecode(error.body) as Map<String, dynamic>;
        return errorData['message'] ?? 'Error: ${error.statusCode}';
      } catch (_) {
        switch (error.statusCode) {
          case 400:
            return 'Invalid request: Please check your input parameters';
          case 401:
            return 'Unauthorized: Please check your API key';
          case 429:
            return 'Too many requests: Please try again later';
          case 500:
            return 'Server error: Please try again later';
          default:
            return 'An error occurred: ${error.statusCode}';
        }
      }
    }
    return 'An error occurred: ${error.toString()}';
  }
}
