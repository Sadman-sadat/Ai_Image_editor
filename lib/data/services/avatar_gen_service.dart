import 'package:appear_ai_image_editor/data/models/avatar_gen_model.dart';
import 'package:appear_ai_image_editor/data/services/api_service_mixin.dart';
import 'package:appear_ai_image_editor/data/utility/urls.dart';

class AvatarGenService with ApiServiceMixin {
  Future<Map<String, dynamic>> generateAvatar(AvatarGenModel model) async {
    return makeApiRequest(
      endpoint: Urls.avatarGen,
      requestData: model.toJson(),
    );
  }
}
