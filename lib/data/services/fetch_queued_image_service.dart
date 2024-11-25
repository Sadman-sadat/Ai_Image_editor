import 'package:image_ai_editor/data/models/fetch_queued_image_model.dart';
import 'package:image_ai_editor/data/services/network_caller.dart';
import 'package:image_ai_editor/data/utility/urls.dart';

class FetchQueuedImageService {
  final NetworkCaller _networkCaller = NetworkCaller();

  Future<String?> fetchQueuedImage(String trackerId, FetchQueuedImageModel model) async {
    final response = await _networkCaller.postRequest(
      Urls.fetchQueued(trackerId),
      model.toJson(),
    );

    if (response['status'] == 'success' && response['output'] != null && response['output'].isNotEmpty) {
      return response['output'][0]; // Return the first URL if available
    } else {
      return null; // Handle cases where no URL is returned
    }
  }
}
