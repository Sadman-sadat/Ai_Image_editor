import 'package:appear_ai_image_editor/data/models/face_swap_model.dart';
import 'package:appear_ai_image_editor/data/services/api_service_mixin.dart';
import 'package:appear_ai_image_editor/data/utility/urls.dart';

class FaceSwapService with ApiServiceMixin {
  Future<Map<String, dynamic>> swapFace(FaceSwapModel model) async {
    return makeApiRequest(
      endpoint: Urls.faceSwap,
      requestData: model.toJson(),
    );
  }
}
