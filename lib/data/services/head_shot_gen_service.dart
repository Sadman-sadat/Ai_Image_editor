import 'package:appear_ai_image_editor/data/models/head_shot_gen_model.dart';
import 'package:appear_ai_image_editor/data/services/api_service_mixin.dart';
import 'package:appear_ai_image_editor/data/utility/urls.dart';

class HeadShotGenService with ApiServiceMixin {
  Future<Map<String, dynamic>> generateHeadShot(HeadShotGenModel model) async {
    return makeApiRequest(
      endpoint: Urls.headShotGen,
      requestData: model.toJson(),
    );
  }
}
