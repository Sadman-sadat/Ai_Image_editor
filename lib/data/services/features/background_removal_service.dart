import 'package:appear_ai_image_editor/data/models/background_removal_model.dart';
import 'package:appear_ai_image_editor/data/services/network/api_service_mixin.dart';
import 'package:appear_ai_image_editor/data/utility/urls.dart';

class BackgroundRemovalService with ApiServiceMixin {
  Future<Map<String, dynamic>> removeBackground(BackgroundRemovalModel model) async {
    return makeApiRequest(
      endpoint: Urls.backgroundRemoval,
      requestData: model.toJson(),
    );
  }
}
