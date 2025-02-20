import 'package:appear_ai_image_editor/data/models/object_removal_model.dart';
import 'package:appear_ai_image_editor/data/services/network/api_service_mixin.dart';
import 'package:appear_ai_image_editor/data/utility/urls.dart';

class ObjectRemovalService with ApiServiceMixin {
  Future<Map<String, dynamic>> removeObject(ObjectRemovalModel model) async {
    return makeApiRequest(
      endpoint: Urls.objectRemoval,
      requestData: model.toJson(),
    );
  }
}
