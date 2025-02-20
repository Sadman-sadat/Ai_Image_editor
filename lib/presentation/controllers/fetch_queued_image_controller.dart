import 'package:get/get.dart';
import 'package:appear_ai_image_editor/data/models/fetch_queued_image_model.dart';
import 'package:appear_ai_image_editor/data/services/fetch_queued_image_service.dart';
import 'package:appear_ai_image_editor/data/utility/urls.dart';

class FetchQueuedImageController extends GetxController {
  bool _inProgress = false;
  String _errorMessage = '';
  String _fetchedImageUrl = '';

  final FetchQueuedImageService _fetchQueuedImageService = FetchQueuedImageService();

  bool get inProgress => _inProgress;
  String get errorMessage => _errorMessage;
  String get fetchedImageUrl => _fetchedImageUrl;

  Future<bool> fetchQueuedImage(String trackerId) async {
    bool isSuccess = false;
    _inProgress = true;
    _errorMessage = '';
    _fetchedImageUrl = '';
    update();

    if (trackerId.isEmpty) {
      _errorMessage = 'Cannot fetch image: trackerId is empty';
      print(_errorMessage);
      _inProgress = false;
      update();
      return false;
    }

    try {
      final fetchQueuedImageModel = FetchQueuedImageModel(
        apiKey: Urls.api_Key,
      );

      final fetchedUrl = await _fetchQueuedImageService.fetchQueuedImage(
        trackerId,
        fetchQueuedImageModel,
      );

      if (fetchedUrl != null && fetchedUrl.isNotEmpty) {
        _fetchedImageUrl = fetchedUrl;
        isSuccess = true;
      } else {
        _errorMessage = 'No image found for tracker ID';
      }
    } catch (error, stackTrace) {
      _errorMessage = 'Error fetching queued image: $error';
      print(_errorMessage);
      print('Stack trace: $stackTrace');
    } finally {
      _inProgress = false;
      update();
    }

    return isSuccess;
  }

  void clearFetchedImageUrl() {
    _fetchedImageUrl = '';
    _errorMessage = '';
    update();
  }
}
