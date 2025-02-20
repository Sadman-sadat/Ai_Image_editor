import 'package:appear_ai_image_editor/data/models/relighting_model.dart';
import 'package:appear_ai_image_editor/data/services/api_service_mixin.dart';
import 'package:appear_ai_image_editor/data/utility/urls.dart';

class RelightingService with ApiServiceMixin {
  Future<Map<String, dynamic>> generateRelighting(RelightingModel model) async {
    return makeApiRequest(
      endpoint: Urls.avatarGen,
      requestData: model.toJson(),
    );
  }
}
