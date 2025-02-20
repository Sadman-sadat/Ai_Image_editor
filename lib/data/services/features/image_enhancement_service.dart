import 'package:appear_ai_image_editor/data/models/image_enhancement_model.dart';
import 'package:appear_ai_image_editor/data/services/network/api_service_mixin.dart';
import 'package:appear_ai_image_editor/data/utility/urls.dart';

class ImageEnhancementService with ApiServiceMixin {
  Future<Map<String, dynamic>> enhancementImage(ImageEnhancementModel model) async {
    return makeApiRequest(
      endpoint: Urls.imageEnhancement,
      requestData: model.toJson(),
    );
  }
}
